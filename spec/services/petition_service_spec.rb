require "rails_helper"

RSpec.describe PetitionService do
  let(:service) { described_class.new }
  let(:mobile_service) { instance_spy MobileApiService }
  let(:petition_repository) { instance_spy PetitionPlugin::DetailRepository }

  its(:mobile_service) { is_expected.to be_a MobileApiService }
  its(:petition_repository) { is_expected.to be_a PetitionPlugin::DetailRepository }

  describe "#fetch_petition_info_with" do
    let(:service) { described_class.new mobile_service: mobile_service }
    let(:fresh) { true }
    let(:petition) do
      double :petition_detail, id: 666, initial_signatures_goal: 10, signatures_required: 100
    end

    let(:api_info) do
      MobileApiService::PetitionInfo.new(Time.current, 4, "blockaddress")
    end

    before do
      allow(mobile_service).to receive(:petition_info).and_return api_info
    end

    subject { service.fetch_petition_info_with petition: petition, fresh: fresh }

    its(:updated_at) { is_expected.to eq api_info.updated_at }
    its(:signatures_count) { is_expected.to eq api_info.signatures_count }
    its(:blockchain_address) { is_expected.to eq api_info.blockchain_address }
    its(:initial_signatures_goal) { is_expected.to eq petition.initial_signatures_goal }
    its(:total_signatures_required) { is_expected.to eq petition.signatures_required }
    its(:current_signatures_goal) { is_expected.to eq 10 }

    context "when not fresh but cached" do
      let(:fresh) { false }

      before { Rails.cache.write "mobile_petition_info:v2:#{petition.id}", api_info }

      it do
        subject
        expect(mobile_service).to_not have_received(:petition_info)
      end
    end
  end

  describe "#fetch_petition_info" do
    let(:service) { described_class.new petition_repository: petition_repository }
    let(:fresh) { true }
    let(:petition) { double :petition_detail, id: 666 }
    let(:api_info) { double }

    before do
      allow(service).to receive(:fetch_petition_info_with)
        .with(petition: petition, fresh: fresh)
        .and_return api_info

      allow(petition_repository).to receive(:find_by_id!)
        .with(petition.id)
        .and_return petition
    end

    subject { service.fetch_petition_info petition.id, fresh: fresh }

    it { is_expected.to eq api_info }
  end

  describe "#compute_current_signatures_goal" do
    let(:signatures_count) { 10 }
    let(:initial_signatures_goal) { 20 }
    let(:total_signatures_required) { 100 }

    subject do
      service.compute_current_signatures_goal signatures_count: signatures_count,
                                              initial_signatures_goal: initial_signatures_goal,
                                              total_signatures_required: total_signatures_required
    end

    it "is the initial goal" do
      is_expected.to eq initial_signatures_goal
    end

    context "when the signatures count is equal the goal" do
      let(:signatures_count) { 20 }
      it { is_expected.to eq initial_signatures_goal * 2 }
    end

    signatures_count = (25..100).step(20)
    expected_goal = (40..100).step(20).to_a
    signatures_count.each_with_index do |count, index|
      context "when the count increases and pass the current goal" do
        let(:signatures_count) { count }

        it "doubles the initial goal" do
          is_expected.to eq expected_goal[index]
        end
      end
    end
  end
end
