require "rails_helper"

RSpec.describe PetitionPlugin::PetitionSigner do
  let(:use_case) { described_class.new }

  its(:presignature_repository) { is_expected.to be_a PetitionPlugin::PresignatureRepository }

  describe "#perform" do
    let(:presignature_repository) { instance_spy PetitionPlugin::PresignatureRepository }

    let(:use_case) { described_class.new presignature_repository: presignature_repository }

    let(:user_id) { 666 }
    let(:plugin_relation_id) { 777 }

    before do
      allow(presignature_repository).to receive(:user_signed_petition?)
        .with(user_id, plugin_relation_id)
        .and_return false
    end

    subject { use_case.perform user_id: user_id, plugin_relation_id: plugin_relation_id }

    it { is_expected.to be }

    it "signs the petition" do
      subject

      expect(presignature_repository).to have_received(:persist!) do |persisted_obj|
        aggregate_failures do
          expect(persisted_obj.user_id).to eq user_id
          expect(persisted_obj.plugin_relation_id).to eq plugin_relation_id
        end
      end
    end

    context "when the user has already signed" do
      before do
        allow(presignature_repository).to receive(:user_signed_petition?)
          .with(user_id, plugin_relation_id)
          .and_return true
      end

      it { is_expected.to_not be }

      it do
        subject
        expect(presignature_repository).to_not have_received(:persist!)
      end
    end
  end
end
