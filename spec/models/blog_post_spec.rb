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

require 'rails_helper'

RSpec.describe BlogPost, type: :model do
  subject { FactoryGirl.build_stubbed(:blog_post) }
  let(:blog_post) { FactoryGirl.build(:blog_post) }

  include_examples 'friendly_id', :title
  include_examples 'paranoia'

  # PRESENCE
  [:title, :content].each do |attr|
    it  "should validate the presence of #{attr} " do
      should validate_presence_of attr
    end
  end

  it 'should belong to plugin_relation' do
    should belong_to :plugin_relation
  end

  describe 'plugin type ' do
    it 'blog should be valid ' do
      valid_post = FactoryGirl.build(:blog_post)

      expect(valid_post).to be_valid
    end

    ['discussion', 'compilation', 'static_page'].each do |type|
      it "#{type} should not be valid" do
        fac_name =  "cycle_#{type}_plugin_relation"
        fac = FactoryGirl.create(fac_name.to_sym)
        invalid_post =  FactoryGirl.build(:blog_post, plugin_relation_id: fac.id)
        expect(invalid_post).to be_invalid
      end
    end

  end

  #RESPONDS_TO
  [:id, :plugin_relation_id, :plugin_relation, :title, :content, :picture, :is_readonly,
   :release_date, :slug, :deleted_at, :created_at, :updated_at, :related].each do |method|
    it "should respond to #{method}" do
      should respond_to(method)
    end
  end

  it 'should have attached picture' do
    should have_attached_file(:picture)
  end

  it "should validate that the presence of the picture" do
    should validate_attachment_presence(:picture)
  end

  it "should validate the content type of the picture" do
    should validate_attachment_content_type(:picture).allowing('image/png','image/gif','image/jpeg','image/jpg').rejecting('text/plain','text/xml')
  end

  [:cycle, :plugin, :related].each do |attr|
    it "should delegate #{attr} to plugin_relation" do
      should delegate_method(attr).to(:plugin_relation)
    end
  end
end
