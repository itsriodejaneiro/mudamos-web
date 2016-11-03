require "rails_helper"

RSpec.describe PetitionPlugin::PresignatureRepository do
  let(:repository) { described_class.new }

  describe "#user_signed_petition?" do
    let(:user) { FactoryGirl.create :user }
    let(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :petition }] }
    let(:plugin_relation) { cycle.plugin_relations.first }

    subject { repository.user_signed_petition? user.id, plugin_relation.id }

    it { is_expected.to_not be }

    context "when the user has signed" do
      before { FactoryGirl.create :petition_plugin_presignature, user: user, plugin_relation: plugin_relation }

      it { is_expected.to be }
    end
  end
end
