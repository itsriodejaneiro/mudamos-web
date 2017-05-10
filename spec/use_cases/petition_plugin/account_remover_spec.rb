require "rails_helper"

RSpec.describe PetitionPlugin::AccountRemover do
  let(:use_case) { described_class.new }

  its(:service) { is_expected.to be_a MobileApiService }

  describe "#perform" do
    let(:service) { instance_spy MobileApiService }
    let(:email) { "le@email.com" }

    let(:use_case) { described_class.new service: service }

    before { allow(service).to receive(:remove_account).with(email: email) }

    subject { use_case.perform email: email }

    its(:success) { is_expected.to be }

    it do
      subject
      expect(service).to have_received(:remove_account).with(email: email)
    end

    context "when a validation error occurs" do
      before do
        allow(service).to receive(:remove_account).with(email: email)
          .and_raise MobileApiService::ValidationError.new("error", [])
      end

      its(:success) { is_expected.not_to be }
    end
  end
end
