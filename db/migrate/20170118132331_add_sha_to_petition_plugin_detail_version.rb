class AddShaToPetitionPluginDetailVersion < ActiveRecord::Migration
  def change
    add_column :petition_plugin_detail_versions, :sha, :string
  end
end
