require "rails_helper"

RSpec.describe UserAccountSync do
  let(:sqs_service) { instance_spy AwsService::SQS }
  let(:use_case) { described_class.new sqs_service: sqs_service }

  describe "#perform" do
    let(:user) { build :user }
    let(:expected_payload) {
      {
        id: user.id,
        name: user.name,
        email: user.email,
        profile: user.profile.name,
        sub_profile: user.sub_profile.try(:name),
        gender: user.gender,
        birthday: user.birthday.strftime("%Y-%m-%d"),
        picture_url: user.picture.url,
        password: user.encrypted_password,
        cpf: user.cpf
      }
    }

    let(:queue_name) { "user_sync_queue" }

    subject do
      with_env user_sync_queue: queue_name do
        use_case.perform user
      end
    end

    it "publishes the message with the correct payload" do
      subject
      expect(sqs_service).to have_received(:publish_message).with queue_name, expected_payload
    end

    context "when the user is nil" do
      let(:user) { nil }

      it { expect{ subject }.to raise_error ArgumentError }
      it { expect(sqs_service).to_not have_received(:publish_message) }
    end
  end
end

