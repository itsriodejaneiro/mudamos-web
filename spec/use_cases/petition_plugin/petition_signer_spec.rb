require "rails_helper"

RSpec.describe PetitionPlugin::PetitionSigner do
  let(:use_case) { described_class.new }

  its(:presignature_repository) { is_expected.to be_a PetitionPlugin::PresignatureRepository }
  its(:mailer) { is_expected.to be PetitionPlugin::PreSignatureMailer }

  describe "#perform" do
    let(:presignature_repository) { instance_spy PetitionPlugin::PresignatureRepository }
    let(:mailer) { class_spy PetitionPlugin::PreSignatureMailer }
    let(:mail) { double :mail, deliver_later: nil }

    let(:use_case) { described_class.new presignature_repository: presignature_repository, mailer: mailer }

    let(:user) { double :user, id: 666 }
    let(:plugin_relation_id) { 444 }
    let(:plugin_relation) { double :relation, id: plugin_relation_id, related: phase }
    let(:phase) { double :phase }
    let(:petition_detail) { double :detail, plugin_relation_id: plugin_relation_id, plugin_relation: plugin_relation }
    let(:petition_detail_version) { double :version, petition_plugin_detail: petition_detail }

    let(:user_password) { nil }

    before do
      allow(mailer).to receive(:just_signed).and_return mail
      allow(presignature_repository).to receive(:user_signed_petition?)
        .with(user.id, plugin_relation_id)
        .and_return false
    end

    subject do
      use_case.perform user: user,
                       petition_detail_version: petition_detail_version,
                       user_password: user_password
    end

    it { is_expected.to be }

    it "signs the petition" do
      subject

      expect(presignature_repository).to have_received(:persist!) do |persisted_obj|
        aggregate_failures do
          expect(persisted_obj.user_id).to eq user.id
          expect(persisted_obj.plugin_relation_id).to eq plugin_relation_id
        end
      end
    end

    it "enqueus the email" do
      subject

      expect(mail).to have_received(:deliver_later)
    end

    it "prepares the email" do
      subject
      expect(mailer).to have_received(:just_signed)
        .with user: user, phase: phase, user_password: nil
    end

    context "when the user has already signed" do
      before do
        allow(presignature_repository).to receive(:user_signed_petition?)
          .with(user.id, plugin_relation_id)
          .and_return true
      end

      it { is_expected.to_not be }

      it do
        subject
        expect(presignature_repository).to_not have_received(:persist!)
      end
    end

    context "with a user password" do
      let(:user_password) { "xpto" }

      it "prepares the email" do
        subject
        expect(mailer).to have_received(:just_signed)
          .with user: user, phase: phase, user_password: user_password
      end
    end
  end
end
