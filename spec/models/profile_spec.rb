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

require 'rails_helper'


RSpec.describe Profile, type: :model do
  subject {FactoryGirl.build(:profile)}

  include_examples 'paranoia'

  # PRESENCE
  [:name].each do |attr|
    it "should validate the presence of #{attr}" do
      should validate_presence_of attr
    end
  end

  it "Should have attached picture" do
    should have_attached_file(:picture)
  end

  # PICTURE VALIDATIONS
  # it "should validate that the presence of the picture" do
  #   should validate_attachment_presence(:picture)
  # end

  it "should validate the content type of the picture" do
    should validate_attachment_content_type(:picture).allowing('image/png','image/gif','image/jpeg','image/jpg').rejecting('text/plain','text/xml')
  end

  it "should have many users" do
    should have_many :users
  end
end
