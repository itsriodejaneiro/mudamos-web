require "rails_helper"

RSpec.describe PluginRepository do
  let(:repository) { described_class.new }

  its(:plugin_type_repository) { is_expected.to be_a PluginTypeRepository }

  describe "#all_with_phases" do
    let(:plugin_type_repository) { instance_spy PluginTypeRepository }
    let!(:plugin_with_phase) { FactoryGirl.create :plugin, plugin_type: "ohmygod" }
    let!(:plugin_without_phase) { FactoryGirl.create :plugin, plugin_type: "ohnoes" }
    let(:types_with_phases) { [plugin_with_phase.plugin_type] }
    let(:types_without_phases) { [plugin_without_phase.plugin_type] }

    before do
      repository.plugin_type_repository = plugin_type_repository

      allow(plugin_type_repository).to receive(:available_types_with_phases).and_return types_with_phases
    end

    subject { repository.all_with_phases }

    it do
      aggregate_failures do
        is_expected.to have(1).plugin
        is_expected.to include plugin_with_phase
      end
    end
  end

  describe "#all_without_phases" do
    let(:plugin_type_repository) { instance_spy PluginTypeRepository }
    let!(:plugin_with_phase) { FactoryGirl.create :plugin, plugin_type: "ohmygod" }
    let!(:plugin_without_phase) { FactoryGirl.create :plugin, plugin_type: "ohnoes" }
    let(:types_with_phases) { [plugin_with_phase.plugin_type] }
    let(:types_without_phases) { [plugin_without_phase.plugin_type] }

    before do
      repository.plugin_type_repository = plugin_type_repository

      allow(plugin_type_repository).to receive(:available_types_without_phases).and_return types_without_phases
    end

    subject { repository.all_without_phases }

    it do
      aggregate_failures do
        is_expected.to have(1).plugin
        is_expected.to include plugin_without_phase
      end
    end
  end

  describe "#find_by_name" do
    let(:name) { "deadpool" }
    let!(:plugin) { FactoryGirl.create :plugin, name: name }
    let!(:another_plugin) { FactoryGirl.create :plugin, name: "yolo" }

    subject { repository.find_by_name name }

    it { is_expected.to eq plugin }
  end
end
