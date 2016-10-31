require "rails_helper"

RSpec.describe PlipRepository do
  let(:repository) { described_class.new }

  subject { repository }

  its(:petition_repository) { is_expected.to be_a PetitionRepository }

  describe "#all_initiated" do
    let(:page) { 1 }
    let(:limit) { 2 }
    let(:item_count) { 1 }
    let(:has_next) { false }

    let!(:one_cycle) { create_cycle_with_phase phases: [{ plugin_type: :petition }] }
    let!(:one_phase) { one_cycle.phases.first }

    let!(:two_cycle) { create_cycle_with_phase phases: [{ plugin_type: :report }] }
    let!(:not_initiated) do
      create_cycle_with_phase phases: [
        {
          plugin_type: :petition,
          attrs: { initial_date: 1.day.from_now, final_date: 2.days.from_now }
        }
      ]
    end

    subject(:pagination) { repository.all_initiated page: page, limit: limit }

    it_behaves_like "a pagination"

    describe "#items#first" do
      subject { pagination.items.first }

      it do
        aggregate_failures do
          expect(subject.document_url).to be_present
          expect(subject.content).to be_present
          expect(subject.phase).to eq one_phase
        end
      end
    end
  end
end
