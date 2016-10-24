# == Schema Information
#
# Table name: profiles
#
#  id                   :integer          not null, primary key
#  name                 :string
#  short_name           :string
#  description          :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  parent_id            :integer
#  lft                  :integer          not null
#  rgt                  :integer          not null
#  depth                :integer          default(0), not null
#  children_count       :integer          default(0), not null
#

class Profile < ActiveRecord::Base
  acts_as_paranoid

  acts_as_nested_set counter_cache: :children_count

  default_scope { order("profiles.name ASC") }

  has_many :users

  has_attached_file :picture

  validates_presence_of :name
  validates_attachment :picture, :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png", "image/jpg"] }

  validate :check_if_max_depth_reached, on: :create, unless: -> (c) { c.parent_id.nil? }

  def all_attributes
    h = super - [
      "picture_file_size",
      "picture_updated_at",
      "picture_content_type",
      "picture_file_name",
      "deleted_at",
      "created_at",
      "updated_at",
      'rgt',
      'lft',
      'depth'
    ]
    h.push('children')
    h
  end

  private

    def check_if_max_depth_reached
      errors.add(:depth, 'maximum depth for comments reached') if parent.depth >= 2
    end
end
