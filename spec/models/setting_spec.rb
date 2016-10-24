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

require 'rails_helper'

RSpec.describe Setting, type: :model do
  include_examples 'paranoia'

  # PRESENCE
  [:key].each do |attr|
    it  "should validate the presence of #{attr} " do
      should validate_presence_of attr
    end
  end

  [:picture, :value, :picture_and_value].each do |type|
    context "#{type}_setting".to_sym do

      subject { FactoryGirl.build_stubbed("#{type}_setting".to_sym) }
      let(:set) { FactoryGirl.build("#{type}_setting".to_sym) }

      # PRESENCE
      it  "should validate the presence of key " do
        should validate_presence_of :key
      end

      attrs = [ ]
      attrs << :picture if type == :picture
      attrs << :value if type == :value
      attrs.each do |attr|
        it  "should validate the presence of #{attr} using validator" do
          set.send "#{attr}=",nil
          set.valid?
          set.errors[:base].should eq ['Choose a value or picture for this setting']
        end
      end

      #UNIQUENESS
      it 'should validate the uniqueness of key' do
        set.should validate_uniqueness_of :key
      end

      if type != :value
        context 'picture checks' do
          it "Should have attached picture" do
            should have_attached_file(:picture)
          end

          it "should validate the content type of the picture" do
            should validate_attachment_content_type(:picture).allowing('image/png','image/gif','image/jpeg','image/jpg').rejecting('text/plain','text/xml')
          end
        end
      end
    end
  end
end
