# Usage:
#   let(:phase) { "a phase" }
#   subject(:phase_response) { {} }
RSpec.shared_examples_for "a phase response" do
  its([:id]) { is_expected.to eq phase.id }
  its([:cycle_id]) { is_expected.to eq phase.cycle_id }
  its([:name]) { is_expected.to eq phase.name }
  its([:description]) { is_expected.to eq phase.description }
  its([:status]) { is_expected.to eq phase.current_status }
  its([:initial_date]) { is_expected.to eq phase.initial_date.to_date.iso8601 }
  its([:final_date]) { is_expected.to eq phase.final_date.to_date.iso8601 }
end
