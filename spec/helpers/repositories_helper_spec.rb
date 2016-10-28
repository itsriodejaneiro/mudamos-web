require "rails_helper"

RSpec.describe RepositoriesHelper do
  describe "#plugin_repository" do
    subject { helper.plugin_repository }

    it { is_expected.to be_a PluginRepository }
  end
end
