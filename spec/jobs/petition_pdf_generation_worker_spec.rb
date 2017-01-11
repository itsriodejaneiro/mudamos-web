require "rails_helper"

RSpec.describe PetitionPdfGenerationWorker do
  let(:petition_pdf_service) { instance_spy PetitionPdfService }
  let(:detail_version_repository) { instance_spy PetitionPlugin::DetailVersionRepository }
  let(:worker) { described_class.new petition_pdf_service: petition_pdf_service, repository: detail_version_repository }

  describe "#perform" do
    let!(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :petition }] }
    let!(:phase) { cycle.phases.first }
    let!(:detail) { create :petition_plugin_detail, plugin_relation: phase.plugin_relation }
    let!(:version) { create :petition_plugin_detail_version, petition_plugin_detail: detail, published: false }

    let(:document_url) { "https://teste.s3-us-west-2.amazonaws.com/seguranca-publica-peticao-1-1.pdf" }

    subject { worker.perform nil, "{ \"id\": #{version.id} }" }

    before do
      allow(petition_pdf_service).to receive(:generate).and_return document_url
      allow(detail_version_repository).to receive(:find_by_id!).with(version.id).and_return(version)
    end

    it "generates the pdf and publishes the version" do

      aggregate_failures do
        subject
        expect(version.reload.published).to eq true
        expect(version.reload.document_url).to eq document_url
      end
    end

    context "when the body is invalid" do
      subject { worker.perform nil, "{" }

      it { expect { subject }.to raise_error JSON::ParserError }
    end
  end
end
