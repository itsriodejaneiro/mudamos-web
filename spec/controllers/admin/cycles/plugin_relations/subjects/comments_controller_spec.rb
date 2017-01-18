require 'rails_helper'

RSpec.describe Admin::Cycles::PluginRelations::Subjects::CommentsController, type: :controller do
  let(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :report }] }
  let(:phase) { cycle.phases.first }
  let(:plugin_relation) { phase.plugin_relation }
  let(:subject) { FactoryGirl.create :base_subject, plugin_relation: plugin_relation }
  let(:comment) { FactoryGirl.create :comment, subject: subject }

  before(:each) do
    admin = FactoryGirl.create(:admin_user)
    sign_in admin
  end

  after(:each) do
    sign_out :admin_user
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, cycle_id: cycle.id, plugin_relation_id: plugin_relation.id, subject_id: subject.id, id: comment.id
      expect(response).to have_http_status(:success)
    end
  end

end
