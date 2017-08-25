require "rails_helper"

RSpec.describe PetitionPublisherWorker do
  subject { described_class.new }

  its(:repository) { is_expected.to be_a PetitionPlugin::DetailVersionRepository }
  its(:petition_service) { is_expected.to be_a PetitionService }
  its(:notifier) { is_expected.to be PetitionNotifierWorker }

  describe "#perform" do
    let(:detail_version_repository) { instance_spy PetitionPlugin::DetailVersionRepository }
    let(:petition_service) { instance_spy PetitionService }
    let(:notifier) { class_spy PetitionNotifierWorker }
    let(:worker) { described_class.new repository: detail_version_repository }
    let(:detail){ spy PetitionPlugin::Detail.new id: 1 }
    let(:version) do
      spy PetitionPlugin::DetailVersion.new, id: 2, petition_plugin_detail_id: detail.id
    end
    let(:versions) { [version] }

    let(:worker) do
      described_class.new repository: detail_version_repository,
                          petition_service: petition_service,
                          notifier: notifier
    end

    before do
      allow(version).to receive(:nationwide?).and_return true
      allow(version).to receive(:petition_plugin_detail).and_return detail
      allow(detail).to receive(:petition_detail_versions).and_return versions
      allow(detail_version_repository).to receive(:find_by_id).with(version.id).and_return(version)
      allow(petition_service).to receive(:fetch_past_versions)
        .with(version.petition_plugin_detail_id, fresh: true)
    end

    subject { worker.perform nil, JSON.dump(id: version.id) }

    it "publishes the version" do
      subject
      expect(version).to have_received(:update!).with(published: true)
    end

    it "refreshes the past versions cache" do
      subject
      expect(petition_service).to have_received(:fetch_past_versions)
        .with(version.petition_plugin_detail_id, fresh: true)
    end

    it "schedules a notification" do
      subject
      expect(notifier).to have_received(:perform_async).with id: version.id
    end

    context "when the body is invalid" do
      subject { worker.perform nil, "{" }

      it { expect { subject }.to raise_error JSON::ParserError }
    end

    context "when it is not the first version" do
      let(:versions) { [double, double] }

      it do
        subject
        expect(notifier).to_not have_received(:perform_async)
      end
    end
  end
end
