# Usage:
#   let(:cycle) { "a cycle" }
#   subject(:cycle_response) { {} }
RSpec.shared_examples_for "a cycle response" do
  its([:id]) { is_expected.to eq cycle.id }
  its([:name]) { is_expected.to eq cycle.name }
  its([:title]) { is_expected.to eq cycle.title }
  its([:color]) { is_expected.to eq cycle.color }
  its([:description]) { is_expected.to eq cycle.description }
  its([:initial_date]) { is_expected.to eq cycle.initial_date.to_date.iso8601 }
  its([:final_date]) { is_expected.to eq cycle.final_date.to_date.iso8601 }

  describe "pictures" do
    subject { cycle_response[:pictures] }

    its([:original]) { is_expected.to include cycle.picture.url(:original) }
    its([:thumb]) { is_expected.to include cycle.picture.url(:thumb) }
    its([:header]) { is_expected.to include cycle.picture.url(:header) }
  end
end
