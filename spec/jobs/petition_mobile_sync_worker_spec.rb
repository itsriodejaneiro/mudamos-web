require "rails_helper"

RSpec.describe PetitionMobileSyncWorker do
  let(:detail_version_repository) { instance_spy PetitionPlugin::DetailVersionRepository }
  let(:mobile_api_service) { instance_spy MobileApiService }
  let(:worker) { described_class.new repository: detail_version_repository, mobile_api_service: mobile_api_service }

  describe "#perform" do
    let(:version) { spy PetitionPlugin::Detail.new, id: 1 }

    before do
      allow(detail_version_repository).to receive(:find_by_id).with(version.id).and_return(version)
    end

    subject { worker.perform nil, "{ \"id\": #{version.id} }" }

    it "calls the api with the version" do
      subject
      expect(mobile_api_service).to have_received(:register_petition_version).with(version)
    end

    context "when the body is invalid" do
      subject { worker.perform nil, "{" }

      it { expect { subject }.to raise_error JSON::ParserError }
    end
  end
end
