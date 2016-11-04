require "rails_helper"

RSpec.describe PluginRelationRepository do
  let(:repository) { described_class.new }

  it_behaves_like "a repository#finders" do
    let(:cycle) { create_cycle_with_phase }
    let(:model) { cycle.plugin_relations.first }
    let(:inexistent_model) { PluginRelation.new }
  end
end
