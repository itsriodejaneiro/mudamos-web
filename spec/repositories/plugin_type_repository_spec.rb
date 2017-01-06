require "rails_helper"

RSpec.describe PluginTypeRepository do
  let(:repository) { described_class.new }

  describe "#available_types" do
    subject { repository.available_types }

    it { is_expected.to have(6).types }

    it { is_expected.to include "Discussão" }
    it { is_expected.to include "Blog" }
    it { is_expected.to include "Relatoria" }
    it { is_expected.to include "Biblioteca" }
    it { is_expected.to include "Glossário" }
    it { is_expected.to include "Petição" }
  end

  describe "#available_types_with_phases" do
    subject { repository.available_types_with_phases }

    it { is_expected.to have(3).types }

    it { is_expected.to include "Discussão" }
    it { is_expected.to include "Relatoria" }
    it { is_expected.to include "Petição" }
  end

  describe "#available_types_without_phases" do
    subject { repository.available_types_without_phases }

    it { is_expected.to have(3).types }

    it { is_expected.to include "Blog" }
    it { is_expected.to include "Biblioteca" }
    it { is_expected.to include "Glossário" }
  end
end
