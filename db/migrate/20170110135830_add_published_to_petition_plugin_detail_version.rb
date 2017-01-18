class AddPublishedToPetitionPluginDetailVersion < ActiveRecord::Migration
  def change
    add_column :petition_plugin_detail_versions, :published, :boolean, default: false
  end
end
