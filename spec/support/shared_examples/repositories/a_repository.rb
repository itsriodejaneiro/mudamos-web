# Usage:
#   let(:model) { a model }
#   let(:repository) { the repository }
#   let(:inexistent_model) { a blank model }
RSpec.shared_examples_for "a repository#finders" do
  describe "#find_by_id!" do
    subject { repository.find_by_id! model.id }

    it { is_expected.to be_a model.class }
    its(:id) { is_expected.to eq model.id }

    context "not found" do
      let(:model) { inexistent_model }
      it { expect { subject }.to raise_error ActiveRecord::RecordNotFound }
    end
  end
end
