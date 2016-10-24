# == Schema Information
#
# Table name: cycles
#
#  id                   :integer          not null, primary key
#  name                 :string
#  subdomain            :string
#  title                :string
#  about                :string
#  initial_date         :datetime
#  final_date           :datetime
#  slug                 :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  color                :string
#  description          :string
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

class Cycle < ActiveRecord::Base
  acts_as_paranoid
  extend FriendlyId
  friendly_id :title

  include Chartable

  include PgSearch
  pg_search_scope :cycle_search,
                  against: [
                    :title,
                    :about,
                    :description
                  ],
                  ignoring: :accents,
                  using: [:tsearch, :trigram]


  has_many :phases, dependent: :destroy
  accepts_nested_attributes_for :phases, reject_if: :all_blank, allow_destroy: true

  has_many :plugin_relations, as: :related, dependent: :destroy
  has_many :plugins, through: :plugin_relations
  # has_many :subjects, through: :plugin_relations
  # has_many :blog_posts, through: :plugin_relations

  has_many :permissions, as: :target

  has_many :social_links
  has_many :materials, dependent: :destroy
  has_many :vocabularies, dependent: :destroy

  has_many :grid_highlights, as: :target_object

  has_attached_file :picture, preserve_files: true, styles: { header: "1920x1080#", thumb: "550x500#" }, processors: [:thumbnail]

  validates_attachment :picture, presence: true, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "image/jpg"] }

  validates_uniqueness_of :color
  validates_presence_of :name, :title, :initial_date, :final_date, :color, :description, :phases
  validate :validate_dates, unless: -> { self.initial_date.nil? || self.final_date.nil? }

  before_validation :set_dates, if: -> { self.phases.present? }
  before_validation :set_name

  def set_dates
    if self.initial_date.blank?
      self.initial_date = self.phases.map { |x| x.initial_date }.sort.first
    end

    if self.final_date.blank?
      self.final_date = self.phases.map { |x| x.final_date }.sort.last
    end
  end

  def set_name
    self.name = self.title
  end

  def plugin_relations
    me = self
    PluginRelation.where{ (related_id.eq(me.id) & related_type.eq(me.class.to_s)) | (related_id.in(me.phases.pluck(:id)) & related_type.eq('Phase')) }
  end

  def plugins
    me = self
    Plugin.where{
      id.in(me.plugin_relations.pluck(:plugin_id))
    }
  end

  [:subject, :blog_post].each do |attr|
    define_method(attr.to_s.pluralize) do
      me = self
      attr.to_s.camelize.constantize.where{
        plugin_relation_id.in(me.plugin_relations.pluck(:id))
      }
    end
  end

  def all_attributes
    attrs = self.attributes.except(
      "picture_file_size",
      "picture_updated_at",
      "picture_content_type",
      "picture_file_name",
      "deleted_at",
      "created_at",
      "updated_at"
    ).keys

    if self.plugin_relations.where(plugin: compilation).any?
      attrs.push 'compilation_pdf'
    end

    attrs.push 'picture'
    attrs.push 'phases'
    attrs.push 'plugin_relations'
    attrs.push 'subjects'
    attrs.push 'blog_posts'
    attrs.push 'current_phase'
  end

  # def as_json filter = []
  #   self.filtered_attributes.merge(
  #     logo: Setting.find_by_key('logo').picture.as_json,
  #     home_header: Setting.find_by_key('home_header').picture.url(:header)
  #   )
  # end

  def finished?
    self.final_date <= Time.zone.now
  end

  def compilation
    Plugin.where(plugin_type: 'Relatoria').first
  end

  def compilation_pdf
    pr = self.plugin_relations.where(plugin: compilation).first
    cf = pr.compilation_file

    if cf.file.exists?
      cf.file.url
    else
      nil
    end
  end

  def current_phase
    self.phases.in_progress.first
  end

  def past_phases
    self.phases.finished
  end

  def blog_plugin
    if self.plugin_relations.any?
      self.plugin_relations.blog.first
    else
      nil
    end
  end

  def next_subject subject_id=nil
    s = subjects.where{ id > subject_id }.limit(1)

    s.empty? ? s << subjects.limit(1).first : nil

    s.first
  end


  def users
    me = self
    User.joins{ profile }.joins{ subjects_users }.where{ subjects_users.subject_id.in( me.subjects.pluck(:id) ) }.uniq
  end

  def user_count_in_range(start_date, end_date)
    users.in_daterange(start_date, end_date).group("DATE_TRUNC('day', users.created_at)").count
  end

  def comments
    me = self
    Comment.joins{ user.profile }.joins{ subject }.where{ subjects.plugin_relation_id.in(me.plugin_relations.pluck(:id)) }
  end

  def initial_date
    super || self.phases.order('initial_date ASC').pluck(:initial_date).first
  end

  def final_date
    super || self.phases.order('final_date DESC').pluck(:final_date).first
  end

  def happening?
    if self.initial_date < Time.zone.now and self.final_date > Time.zone.now
      true
    else
      false
    end
  end

  def status
    if self.happening?
      'Em andamento'
    elsif self.initial_date > Time.zone.now
      'Ainda não iniciado'
    else
      'Finalizado'
    end
  end

    private

    def validate_dates
      if initial_date > self.final_date
        errors.add(:initial_date, 'must come before final_date')
        errors.add(:final_date, 'must come after initial_date')
      end
    end
end
