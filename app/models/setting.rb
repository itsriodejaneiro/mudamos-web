# == Schema Information
#
# Table name: settings
#
#  id                   :integer          not null, primary key
#  key                  :string
#  value                :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  deleted_at           :datetime
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

class Setting < ActiveRecord::Base
  acts_as_paranoid

  has_attached_file :picture, preserve_files: true, styles: lambda {
    |attachment| attachment.instance.image? ? { header: "1920x1080#" } : {}
  }, processors: [:thumbnail]
  before_post_process :forbid_svg

  def image?
    picture.content_type.index("image/") == 0
  end

  validates_presence_of :key
  validates_uniqueness_of :key

  validates_attachment :picture, :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png", "image/jpg", "image/svg+xml", "application/pdf"] }

  validate :value_or_picture

  def all_attributes
    keys = super - [
      "picture_file_size",
      "picture_updated_at",
      "picture_content_type",
      "picture_file_name",
      "deleted_at",
      "created_at",
      "updated_at"
    ]

    if self.value.nil?
      keys.delete 'value'
      keys.push 'picture'
    end
  end

  private

  def value_or_picture
    errors.add(:base, 'Choose a value or picture for this setting') unless (value? || picture?)
  end

  def forbid_svg
    if self.picture_content_type.include? "image/"
      ["image/jpeg", "image/jpg", "image/png", "image/gif", "image/jpeg"].include?(self.picture_content_type)
    else
      true
    end
  end
end
