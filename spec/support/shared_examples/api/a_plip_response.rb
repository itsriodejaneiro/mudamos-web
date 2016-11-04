# Usage:
#   let(:cycle) { "a cycle" }
#   let(:phase) { "a phase" }
#   subject(:plip_response) { {} }
RSpec.shared_examples_for "a plip response" do
  its([:document_url]) { is_expected.to be_present }
  its([:content]) { is_expected.to be_present }

  it_behaves_like "a cycle response" do
    subject(:cycle_response) { plip_response[:cycle] }
  end

  it_behaves_like "a phase response" do
    subject(:phase_response) { plip_response[:phase] }
  end
end
