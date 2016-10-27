require "rails_helper"

RSpec.describe PluginHelper do
  describe "#link_to_plugin_page" do
    let(:phase) { cycle.phases.first }
    let(:plugin_relation) { phase.plugin_relation }

    subject { helper.link_to_plugin_page phase }

    context "when report plugin" do
      let(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :report }] }
      it { is_expected.to include cycle_plugin_relation_path(cycle, plugin_relation) }
    end

    context "when petition plugin" do
      let(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :petition }] }
      it { is_expected.to include cycle_plugin_relation_path(cycle, plugin_relation) }
    end

    context "when discussion plugin" do
      let(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :discussion }] }
      it { is_expected.to include cycle_subjects_path(cycle) }
    end

    context "when unknown plugin" do
      let(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :report }] }

      before { phase.plugin.plugin_type = "unknown" }

      it { is_expected.to be_nil }
    end

    context "when the phase has not started yet" do
      let(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :report, attrs: { initial_date: 1.day.from_now } }] }
      it { is_expected.to be_nil }
    end
  end
end
