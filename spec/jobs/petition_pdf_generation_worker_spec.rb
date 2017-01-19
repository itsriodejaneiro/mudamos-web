require "rails_helper"

RSpec.describe PetitionPdfGenerationWorker do
  let(:petition_pdf_service) { instance_spy PetitionPdfService }
  let(:detail_version_repository) { instance_spy PetitionPlugin::DetailVersionRepository }
  let(:worker) { described_class.new petition_pdf_service: petition_pdf_service, repository: detail_version_repository }

  describe "#perform" do
    let(:version) { spy PetitionPlugin::Detail.new, id: 1 }

    let(:document_name) { "seguranca-publica-peticao-1-1" }
    let(:document_url) { "https://teste.s3-us-west-2.amazonaws.com/#{document_name}.pdf" }
    let(:sha) { "asdasdasdasd" }
    let(:generated_version) { PetitionPdfService::Result.new document_name, sha, document_url  }

    before do
      allow(petition_pdf_service).to receive(:generate).and_return generated_version
      allow(detail_version_repository).to receive(:find_by_id!).with(version.id).and_return(version)
    end

    subject { worker.perform nil, "{ \"id\": #{version.id} }" }

    it "generates the pdf and updates the version" do
      subject
      expect(version).to have_received(:update).with(sha: sha, document_url: document_url)
    end

    context "when the body is invalid" do
      subject { worker.perform nil, "{" }

      it { expect { subject }.to raise_error JSON::ParserError }
    end
  end
end
