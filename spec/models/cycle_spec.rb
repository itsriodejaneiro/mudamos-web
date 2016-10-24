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

require 'rails_helper'

RSpec.describe Cycle, type: :model do
  subject { FactoryGirl.build_stubbed(:cycle) }
  let(:cycle) { FactoryGirl.build(:cycle) }

  include_examples 'friendly_id', :title
  include_examples 'paranoia'

  # PRESENCE
  [:name, :subdomain, :title, :about, :initial_date, :final_date, :color, :description].each do |attr|
    it  "should validate the presence of #{attr} " do
      should validate_presence_of attr
    end
  end

  # UNIQUENESS
  it 'should validate uniqueness of color' do
    cycle.should validate_uniqueness_of :color
  end

  # TESTING DATES
  describe "when the final_date is" do
    subject{FactoryGirl.build(:cycle, initial_date: Date.today, final_date: Date.today )}
    context "before initial_date" do
      (-100..-1).each do |n|
        it "should not be valid" do
          should_not allow_value(n.days.from_now).for(:final_date)
        end
      end
    end

    context "the same day as initial_date" do
      it "should not be valid" do
        should allow_value(Time.zone.now.beginning_of_day).for(:final_date)
      end
    end

    context "after initial_date" do
      (1..100).each do |n|
        it "should be valid for final_date as #{n.days.from_now.to_date}" do
          should allow_value(n.days.from_now).for(:final_date)
        end
      end
    end
  end

  # HAS MANY
  [:phases, :plugin_relations].each do |attr|
    it "should have many #{attr}" do
      should have_many(attr).dependent(:destroy)
    end
  end

  it "should have many plugins through plugin_relations" do
    should have_many(:plugins).through(:plugin_relations)
  end

  it 'should have many permissions' do
    should have_many :permissions
  end

  # PICTURE
  it 'should have attached picture' do
    should have_attached_file(:picture)
  end

  it "should validate that the presence of the picture" do
    should validate_attachment_presence(:picture)
  end

  it "should validate the content type of the picture" do
    should validate_attachment_content_type(:picture).allowing('image/png','image/gif','image/jpeg','image/jpg').rejecting('text/plain','text/xml')
  end
end

