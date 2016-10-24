# == Schema Information
#
# Table name: comments
#
#  id                     :integer          not null, primary key
#  subject_id             :integer
#  user_id                :integer
#  content                :text
#  was_intermediated      :boolean          default(FALSE)
#  should_show_alias      :boolean
#  parent_id              :integer
#  lft                    :integer          not null
#  rgt                    :integer          not null
#  depth                  :integer          default(0), not null
#  children_count         :integer          default(0), not null
#  likes_count            :integer          default(0), not null
#  dislikes_count         :integer          default(0), not null
#  reports_count          :integer          default(0), not null
#  comment_versions_count :integer          default(0), not null
#  slug                   :string
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_anonymous           :boolean
#

class Comment < ActiveRecord::Base
  acts_as_paranoid

  # extend FriendlyId
  # friendly_id :content

  acts_as_nested_set counter_cache: :children_count

  scope :with_includes, -> { includes(:user, likes: :user, dislikes: :user, reports: :user) }

  scope :most_recent, -> { all.sort_by { |x| x.descendants.order('created_at DESC').limit(1).pluck(:created_at).first || x.created_at }.reverse }
  scope :most_answered, -> { all.sort_by { |x| x.descendants.count }.reverse }
  scope :most_liked, -> { all.sort_by { |x| x.likes.count }.reverse }
  scope :most_disliked, -> { all.sort_by { |x| x.dislikes.count }.reverse }

  belongs_to :subject
  belongs_to :user

  include PgSearch
  pg_search_scope :comments_search,
                  against: [
                    :content,
                  ],
                  ignoring: :accents,
                  using: [:tsearch, :trigram]


  def user
    User.unscoped.where(id: self.user_id).first
  end

  has_many :likes
  has_many :dislikes
  has_many :reports

  has_many :notifications, as: :target_object, dependent: :destroy

  scope :in_daterange, -> (start_date, end_date) {
    where(created_at: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day)
  }

  def self.hot list
    @@comment_count = nil
    @@profile_count = nil
    list.to_a.sort_by { |x| -x.final_score }
  end

  def self.recent list
    list.order('created_at DESC')
  end

  def self.most_commented list
    list.order('children_count DESC')
  end

  def self.sectorized list
    list.includes(:user, user: :profile).order('profiles.name ASC')
  end

  def normalized_comments_score
    n = self.descendants.count.to_f / ((@@comment_count ||= Comment.count).to_f * 0.15)
    if n > 1
      n = 1
    end

    n
  end

  def normalized_profile_score
    me = self
    Comment.where{
      id.in(me.descendants.pluck(:id) + [me.id])
    }.includes(
      :user
    ).map do |x|
      [x.user.profile_id, x.user.sub_profile_id]
    end.flatten.uniq.reject do |x|
      x.nil?
    end.count.to_f / (@@profile_count ||= Profile.count).to_f
  end

  def normalized_time_life_score
    init_date = self.subject.plugin_relation.cycle.initial_date
    if init_date > Time.zone.now
      0
    else
      (self.created_at.to_f - init_date.to_f) / (Time.zone.now.to_f - init_date.to_f)
    end
  end

  def final_score
    self.normalized_comments_score + self.normalized_profile_score + self.normalized_time_life_score
  end

  def subject_user
    SubjectUser.where(user: self.user, subject: self.subject).limit(1).first
  end

  def author
    if self.user
      is_anonymous? ? self.user.alias_name : self.user.name
    else
      nil
    end
  end

  def photo
    self.is_anonymous ? self.user.anonymous_picture_url : self.user.picture(:thumb)
  end

  def comments_to_notify
    Comment.where(id: ([self.root.id] + self.root.descendants.pluck(:id)))
  end

  def liked_by? user
    self.likes.where(user: user).any?
  end

  def disliked_by? user
    self.dislikes.where(user: user).any?
  end

  def all_attributes
    super + [:likes, :dislikes]
  end

  def parents_id
    obj = self

    ids = []
    ids.push obj.id
    while obj.parent.present?
      ids.push obj.parent_id
      obj = obj.parent
    end

    ids.reverse
  end

  def parents_url_params
    self.parents_id.map { |x| "comment-#{x}" }.join(",")
  end

  def comment_profile_count_in_range(start_date, end_date, month = false)
    start_date = start_date.to_date
    end_date = end_date.to_date

    c = includes(:user, user: :profile).children.in_daterange(start_date, end_date).group('profiles.name').group("DATE_TRUNC('#{month ? 'month' : 'day'}', comments.created_at)").count

    convert_to_all_profiles_range c, start_date, end_date, month
  end

  validates_presence_of :subject, :user, :content
  validate :check_if_max_depth_reached, on: :create, unless: -> (c) { c.parent_id.nil? }

  after_create :create_subject_user, if: -> { self.subject_user.nil? }
  before_validation :set_is_anonymous, if: -> { self.subject_user.present? }
  after_validation :set_is_anonymous_to_false, if: -> { self.is_anonymous.nil? }

  # after_create :notify_parent_author, if: -> {self.parent.present? && (self.parent.user_id != self.user_id)}
  after_commit :notify_comments, if: -> { self.parent.present? }
  after_commit :notify_admins, if: -> { self.depth == 0 }

  private

    def check_if_max_depth_reached
      errors.add(:depth, 'maximum depth for comments reached') if parent.depth > 2
    end

    def create_subject_user
      SubjectUser.create(user: self.user, subject: self.subject, is_anonymous: self.is_anonymous)
    end

    def set_is_anonymous
      self.is_anonymous = self.subject_user.is_anonymous
      true
    end

    def set_is_anonymous_to_false
      self.is_anonymous = false
      true
    end

    def notify_parent_author
      notif = create_notification(self.parent,
                                  "#{self.author} respondeu a um comentário seu!",
                                  "#{self.author} respondeu ao seu comentário: #{self.content.truncate(100, separator: ' ', omission:'...(continua)')} ",
                                  self.photo)

      notify_other_means(notif, self.parent)
    end


    def notify_comments
      self.comments_to_notify.each do |c|
        next if c.user_id == self.user_id or c.id == self.id
        next if Notification.where(
          target_user_id: c.user_id,
          target_user_type: c.user.class.to_s,
          target_object_id: self.id,
          target_object_type: self.class.to_s
        ).any?

        notif = create_notification(c,
          "<b>#{self.author}</b> adicionou um comentário à discussão!",
          "<b>#{self.author}</b> adicionou um comentário'à discussão #{self.root.content.truncate(100, separator: ' ', omission: '...(continua)')}",
          self.photo
        )
        notify_other_means(notif, c)
      end
    end

    def notify_admins
      AdminUser.all.each do |admin|
        notif = create_notification(self,
                                    "<b>#{self.author}</b> adicionou um comentário à discussão!",
                                    "<b>#{self.author}</b> adicionou um comentário'à discussão #{self.root.content.truncate(100, separator: ' ', omission: '...(continua)')}",
                                    self.photo,
                                    admin
        )
        notify_other_means(notif, self)
      end
    end

    def notify_other_means(notification, target)
      # [EmailNotification, InternalNotification, PushNotification].each do |type|
      [InternalNotification, EmailNotification].each do |type|
        next if notification.target_user.is_a? AdminUser and type == EmailNotification

        specific_notification = type.new
        specific_notification.notification = notification

        if type == EmailNotification
          specific_notification.to_email = target.user.email
          specific_notification.from_email = 'contato@mudamos.org'
          specific_notification.subject = notification.title
          specific_notification.content = notification.description
        end
        specific_notification.save!

        # specific_notification.notify
      end
    end

    def create_notification(target, title, desc, picture_url, admin=nil)
      Notification.create!( target_user_id: admin.nil? ? target.user_id : admin.id,
                            target_user_type: admin.nil? ? target.user.class.to_s : admin.class.to_s,
                            target_object_id: self.id,
                            target_object_type: self.class.to_s,
                            title: title,
                            picture_url: picture_url,
                            description: desc,
                            view_url: "#{Rails.application.routes.url_helpers.cycle_subject_path(self.subject.plugin_relation.cycle, self.subject)}?comments=#{self.parents_url_params}")
    end

    def self.to_csv
      CSV.generate(col_sep: "\t") do |csv|
        h = {
          id: "ID",
          parent_id: "ID do Comentário Pai",
          content: "Conteúdo",
          created_at: "Data de Criação",
          is_anonymous: "Anônimo",
          depth: "Nível",
          subject: "Asssunto",
          descendants_count: "Total de Respostas",
          cycle: "Ciclo",
          user_id: "ID do Usuário",
          user_name: "Nome do Usuário"
        }

        csv << h.values

        self.includes(:subject, :user, subject: :plugin_relation).all.each do |item|
          values = h.keys.map do |k|
            case k
            when :cycle
              item.subject.plugin_relation.cycle.name
            when :subject
              item.subject.title
            when :descendants_count
              item.descendants.count
            when :created_at
              item.send(k).strftime("%d/%m/%Y %H:%M ")
            when :user_name
              item.author
            when :user_id
              item.user.id
            else
              item.send(k)
            end
          end

          csv << values
        end
      end
    end

    def self.to_public_csv
      CSV.generate(col_sep: "\t") do |csv|
        h = {
          id: "ID",
          parent_id: "ID do Comentário Pai",
          content: "Conteúdo",
          created_at: "Data de Criação",
          is_anonymous: "Anônimo",
          depth: "Nível",
          subject: "Asssunto",
          user_name: "Nome do Usuário",
          profile: "Setor",
          sub_profile: "Subsetor"
        }

        csv << h.values

        self.includes(:subject, :user, subject: :plugin_relation).joins(:user, user: :profile).all.each do |item|
          values = h.keys.map do |k|
            case k
            when :cycle
              item.subject.plugin_relation.cycle.name
            when :subject
              item.subject.title
            when :content
              ActionController::Base.helpers.strip_tags(item.content.gsub("\t", ""))
            when :descendants_count
              item.descendants.count
            when :created_at
              item.send(k).strftime("%d/%m/%Y %H:%M ")
            when :user_name
              item.author
            when :user_id
              item.user.id
            when :profile
              item.user.profile.present? ? item.user.profile.name : nil
            when :sub_profile
              item.user.sub_profile.present? ? item.user.sub_profile.name : nil
            else
              item.send(k)
            end
          end

          csv << values
        end
      end
    end
end
