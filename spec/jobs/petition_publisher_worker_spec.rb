require "rails_helper"

RSpec.describe PetitionPublisherWorker do

  let(:detail_version_repository) { instance_spy PetitionPlugin::DetailVersionRepository }
  let(:worker) { described_class.new repository: detail_version_repository }

  describe "#perform" do
    let(:version) { spy PetitionPlugin::Detail.new, id: 1 }

    before do
      allow(detail_version_repository).to receive(:find_by_id).with(version.id).and_return(version)
    end

    subject { worker.perform nil, "{ \"id\": #{version.id} }" }

    it "publishes the version" do
      subject
      expect(version).to have_received(:update).with(published: true)
    end

    context "when the body is invalid" do
      subject { worker.perform nil, "{" }

      it { expect { subject }.to raise_error JSON::ParserError }
    end
  end
end
