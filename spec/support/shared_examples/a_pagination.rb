# Usage:
#   let(:item_count) { 2 }
#   let(:page) { 1 }
#   let(:limit) { 3 }
#   let(:has_next) { true }
#
#   subject { pagination_object }
RSpec.shared_examples_for "a pagination" do
  it do
    aggregate_failures do
      is_expected.to be_a Pagination

      expect(subject.items).to have(item_count).item
      expect(subject.page).to eq page
      expect(subject.limit).to eq limit
      expect(subject.has_next).to eq has_next
    end
  end
end
