require "rails_helper"

RSpec.describe PetitionPdfGenerationWorker do
  let(:petition_pdf_service) { instance_spy PetitionPdfService }
  let(:detail_version_repository) { instance_spy PetitionPlugin::DetailVersionRepository }
  let(:worker) { described_class.new petition_pdf_service: petition_pdf_service, repository: detail_version_repository }

  describe "#perform" do
    let(:version) { instance_spy PetitionPlugin::Detail }

    let(:document_url) { "https://teste.s3-us-west-2.amazonaws.com/seguranca-publica-peticao-1-1.pdf" }

    before do
      allow(petition_pdf_service).to receive(:generate).and_return document_url
      allow(version).to receive(:id).and_return 1
      allow(detail_version_repository).to receive(:find_by_id!).with(version.id).and_return(version)
    end

    subject { worker.perform nil, "{ \"id\": #{version.id} }" }

    it "generates the pdf and publishes the version" do
      subject
      expect(version).to have_received(:update).with(published: true, document_url: document_url)
    end

    context "when the body is invalid" do
      subject { worker.perform nil, "{" }

      it { expect { subject }.to raise_error JSON::ParserError }
    end
  end
end
