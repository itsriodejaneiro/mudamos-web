# == Schema Information
#
# Table name: blog_posts
#
#  id                   :integer          not null, primary key
#  plugin_relation_id   :integer
#  title                :string
#  content              :text
#  picture              :string
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  is_readonly          :boolean
#  release_date         :datetime
#  slug                 :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  author_name          :string
#  active               :boolean          default(TRUE)
#  highlighted          :boolean          default(FALSE)
#

class BlogPost < ActiveRecord::Base
  acts_as_paranoid
  extend FriendlyId
  friendly_id :title

  include PgSearch
  pg_search_scope :blog_post_search,
                  against: [
                    :title,
                    :content,
                    :author_name
                  ],
                  ignoring: :accents,
                  using: [:tsearch, :trigram]

  belongs_to :plugin_relation

  has_many :grid_highlights, as: :target_object

  delegate :cycle, :plugin, :related, to: :plugin_relation, allow_nil: true

  has_attached_file :picture, preserve_files: true, styles: { header: "1920x500#", thumb: "570x430#" }, processors: [:thumbnail]

  default_scope { order('release_date DESC, created_at DESC') }

  scope :active, -> { where{ active == true } }
  scope :released, -> { active.where{ release_date < DateTime.now } }
  scope :highlights, -> {
    highlights = released.where{ highlighted == true }.order('RANDOM()').limit(3)

    unless highlights.any?
      highlights = released.limit(3)
    end

    highlights
  }



  validates_attachment :picture, presence: true, content_type: { content_type: ["image/jpeg", "image/gif", "image/jpg", "image/png"] }

  validates_presence_of :title, :content, :release_date
  validate :plugin_type_is_blog?, on: :create, if: -> { self.plugin }

  def attributes_to_filter (filter = [])
    attrs = self.attributes.except(
      "picture_file_size",
      "picture_updated_at",
      "picture_content_type",
      "picture_file_name",
      "deleted_at",
      "created_at",
      "updated_at"
    ).keys

    attrs.push 'picture'
    attrs
  end

  def release_date= value
    if value.is_a? String
      begin
        value = Date.parse(value)
      rescue Exception => e
        value = nil
      end
    end

    super
  end

  def color
    if self.cycle.present?
      self.cycle.color
    else
      nil
    end
  end

  def cycle_name
    self.cycle.present? ? self.cycle.name : "Mudamos"
  end

  def author_name
    super || 'Mudamos'
  end

  private

    def plugin_type_is_blog?
      errors.add(plugin.plugin_type, 'plugin must be a Blog type') if plugin.plugin_type != 'Blog'
    end

  #TODO
  #has_many :blog_comments
end
