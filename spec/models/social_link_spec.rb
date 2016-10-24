# == Schema Information
#
# Table name: social_links
#
#  id          :integer          not null, primary key
#  provider    :string
#  link        :string
#  icon_class  :string
#  description :text
#  cycle_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string
#

require 'rails_helper'

RSpec.describe SocialLink, type: :model do
  subject { FactoryGirl.build_stubbed(:social_link) }
  let(:social_link) { FactoryGirl.build(:social_link) }

  # PRESENCE
  [:provider, :link, :icon_class, :description].each do |attr|
    it  "should validate the presence of #{attr} " do
      should validate_presence_of attr
    end
  end

  #UNIQUENESS
  it 'should validate uniqueness of provider' do
    social_link.should validate_uniqueness_of(:provider).scoped_to(:cycle_id)
  end

  # BELONGS TO
  it 'should belongs to a cycle' do
    should belong_to :cycle
  end

end
