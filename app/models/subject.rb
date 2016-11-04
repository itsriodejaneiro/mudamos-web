# == Schema Information
#
# Table name: subjects
#
#  id                 :integer          not null, primary key
#  plugin_relation_id :integer
#  enunciation        :string
#  slug               :string
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  question           :text
#  title              :string
#  vocabulary_id      :integer
#  tag_description    :text
#  file_file_name     :string
#  file_content_type  :string
#  file_file_size     :integer
#  file_updated_at    :datetime
#

class Subject < ActiveRecord::Base
  acts_as_paranoid
  extend FriendlyId
  friendly_id :title

  include Chartable

  include PgSearch
  pg_search_scope :subject_search,
                  against: [
                    :title,
                    :question,
                    :enunciation
                  ],
                  ignoring: :accents,
                  using: [:tsearch, :trigram]

  belongs_to :plugin_relation
  belongs_to :vocabulary

  has_many :comments, dependent: :destroy
  has_many :subjects_users

  scope :random_order, -> {
    order("RANDOM()")
  }

  has_attached_file :file, preserve_files: true
  validates_attachment :file, content_type: { content_type: ["application/pdf"] }

  validates_presence_of :question, :plugin_relation, :title

  def users
    User.joins(:profile).where(id: comments.pluck(:user_id).uniq)
  end

  def toggle_anonymity_for(user)
    rel = subjects_users.for(user.id).first
    rel.toggle_anonymity if rel
  end

  def is_anonymous_for(user)
    rel = subjects_users.for(user.id).first
    rel.is_anonymous? if rel
  end

  def all_attributes
    attrs = self.attributes.except(
      "file_file_size",
      "file_updated_at",
      "file_content_type",
      "file_file_name"
    ).keys

    if self.plugin_relation.cycle.plugin_relations.where(plugin: compilation).any?
      attrs.push 'file'
    end
  end
end
