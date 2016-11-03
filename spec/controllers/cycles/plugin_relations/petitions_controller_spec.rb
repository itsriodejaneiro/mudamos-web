require "rails_helper"

RSpec.describe Cycles::PluginRelations::PetitionsController do
  let(:current_user) { FactoryGirl.create :user }
  let(:petition_signer) { instance_spy PetitionPlugin::PetitionSigner }
  let(:plugin_relation_repository) { instance_spy PluginRelationRepository }

  subject { controller }

  its(:petition_signer) { is_expected.to be_a PetitionPlugin::PetitionSigner }
  its(:plugin_relation_repository) { is_expected.to be_a PluginRelationRepository }

  describe "POST sign" do
    let(:cycle_id) { 666 }
    let(:plugin_relation) { double id: 777 }
    let(:plugin_relation_id) { plugin_relation.id }

    let(:make_request) { post :sign, cycle_id: cycle_id, plugin_relation_id: plugin_relation_id }
    let(:make_signed_request) do
      sign_in current_user
      make_request
    end

    before do
      controller.petition_signer = petition_signer
      controller.plugin_relation_repository = plugin_relation_repository

      allow(plugin_relation_repository).to receive(:find_by_id!)
        .with(plugin_relation_id.to_s)
        .and_return plugin_relation
    end

    it do
      make_signed_request
      expect(response.status).to eq 200
    end

    it do
      make_signed_request
      expect(petition_signer).to have_received(:perform)
        .with(user_id: current_user.id, plugin_relation_id: plugin_relation_id)
    end

    context "when the user is not signed in" do
      before { make_request }

      it { expect(response.status).to eq 200 }

      it { expect(petition_signer).to_not have_received(:perform) }
    end
  end
end
