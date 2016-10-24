# == Schema Information
#
# Table name: comments
#
#  id                     :integer          not null, primary key
#  subject_id             :integer
#  user_id                :integer
#  content                :text
#  was_intermediated      :boolean          default(FALSE)
#  should_show_alias      :boolean
#  parent_id              :integer
#  lft                    :integer          not null
#  rgt                    :integer          not null
#  depth                  :integer          default(0), not null
#  children_count         :integer          default(0), not null
#  likes_count            :integer          default(0), not null
#  dislikes_count         :integer          default(0), not null
#  reports_count          :integer          default(0), not null
#  comment_versions_count :integer          default(0), not null
#  slug                   :string
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_anonymous           :boolean
#

require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { FactoryGirl.build_stubbed(:comment) }
  let(:comment) { FactoryGirl.build(:comment) }

  include_examples 'friendly_id', :content
  include_examples 'paranoia'

  # PRESENCE
  [:subject, :user, :content].each do |attr|
    it  "should validate the presence of #{attr} " do
      comment.should validate_presence_of attr
    end
  end

  [:subject, :user].each do |model|
    it "should belong to #{model}"  do
      comment.should belong_to model
    end
  end

  #RESPONDS_TO
    [:id, :subject_id, :user_id, :content, :was_intermediated, :should_show_alias,
    :parent_id, :lft, :rgt, :depth, :children_count,
    :likes_count, :dislikes_count, :reports_count, :comment_versions_count,
    :slug, :deleted_at, :created_at, :updated_at].each do |method|
      it "should respond to #{method}" do
        should respond_to(method)
      end
    end

  context 'with nested comments' do
    before(:each) do
      @original_comment = FactoryGirl.create(:comment)
    end

    it 'should increase depth when a new comment is added' do
      new_comment = FactoryGirl.build(:comment, parent: @original_comment)
      expect{ new_comment.save }.to change { new_comment.depth }.by(1)
    end

    it 'should increase children_count when a new comment is added' do
      new_comment = FactoryGirl.build(:comment, parent: @original_comment)
      expect{ new_comment.save }.to change { @original_comment.children_count }.by(1)
    end

    it 'should decrease children_count when a comment is deleted' do
      comment_w_children = FactoryGirl.create(:comment, :with_children, number_of_children: 2)
      expect { comment_w_children.children.first.destroy }.to change { comment_w_children.children.count }.by(-1)
    end

    it 'should create notification when a new comment is added' do
      new_comment = FactoryGirl.build(:comment, parent: @original_comment)
      expect{ new_comment.save }.to change { Notification.count }.by(1)
    end

    [EmailNotification, InternalNotification, PushNotification].each do |type|
      it "should create #{type.to_s} notification when a new comment is added" do
        new_comment = FactoryGirl.build(:comment, parent: @original_comment)
        expect{ new_comment.save }.to change { type.count }.by(1)
      end
    end

    describe 'and one child' do
      before do
        parent = @original_comment
        @new_comment = FactoryGirl.create(:comment, parent: parent)
      end

      it 'should create 2 notifications when a new comment is added' do
        new_comment = FactoryGirl.build(:comment, parent: @original_comment)
        expect{ new_comment.save }.to change { Notification.count }.by(2)
      end

      [EmailNotification, InternalNotification, PushNotification].each do |type|
        it "should create 2 #{type.to_s} notifications when a new comment is added" do
          new_comment = FactoryGirl.build(:comment, parent: @original_comment)
          expect{ new_comment.save }.to change { type.count }.by(2)
        end
      end
    end
    describe 'and with depth bigger than 3' do
      before do
        parent = @original_comment
        
        3.times do
          @new_comment = FactoryGirl.create(:comment, parent: parent)
          parent = @new_comment
        end
      end

      it 'new comment should not be valid' do
        invalid_comment = FactoryGirl.build(:comment, parent: @new_comment)

        expect(invalid_comment).to be_invalid
      end
    end
  end

  context 'callbacks' do
    before(:each) do
      @comm = FactoryGirl.build(:comment)
    end

    it "should call :create_subject_user after create" do
      expect(@comm).to callback(:create_subject_user).after(:create)
    end


  end
end
