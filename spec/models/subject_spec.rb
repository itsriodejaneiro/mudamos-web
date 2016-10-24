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
#

require 'rails_helper'

RSpec.describe Subject, type: :model do
  [:phase_subject, :cycle_subject].each do |factory|
    subject { FactoryGirl.build_stubbed(factory) }
    let(:subject) { FactoryGirl.build(factory) }

    include_examples 'friendly_id', :title, factory
    include_examples 'paranoia', factory

    # PRESENCE
    [:question, :plugin_relation].each do |attr|
      it  "#{factory} should validate the presence of #{attr} " do
        should validate_presence_of attr
      end
    end

    it "#{factory} should belong to plugin_relation" do
        should belong_to :plugin_relation
    end

    #RESPONDS_TO
    [:id, :plugin_relation, :question, :enunciation, :slug, :deleted_at, :created_at, :updated_at, :toggle_anonymity_for, :is_anonymous_for].each do |method|
      it "#{factory} should respond to #{method}" do
        should respond_to(method)
      end
    end

    context 'testing anonymity methods' do
      before(:each) do
        @comment = FactoryGirl.create(:comment, is_anonymous: true)
        @subject = @comment.subject
        @user = @comment.user
      end

      it 'should return anonymity for that subject based on the user' do
        @subject.is_anonymous_for(@user).should be(true)
      end

      it 'should NOT return anonymity status for that subject based on the wrong user' do
        wrong_user = FactoryGirl.create(:user)
        @subject.is_anonymous_for(wrong_user).should be(nil)
      end

      it 'should toggle the anonymity status' do
        expect{ @subject.toggle_anonymity_for(@user) }.to change{ @subject.is_anonymous_for(@user) }.from(true).to(false)
      end
      it 'should not toggle the anonymity status for the wrong user' do
        wrong_user = FactoryGirl.create(:user)
        @subject.toggle_anonymity_for(wrong_user)
        @subject.is_anonymous_for(wrong_user).should be(nil)
      end
    end

  end
end
