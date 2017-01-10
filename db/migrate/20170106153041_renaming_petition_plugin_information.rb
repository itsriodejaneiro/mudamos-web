class RenamingPetitionPluginInformation < ActiveRecord::Migration
  def change
    rename_table :petition_plugin_information, :petition_plugin_details
  end
end
