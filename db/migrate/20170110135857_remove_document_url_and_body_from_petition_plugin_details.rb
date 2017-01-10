class RemoveDocumentUrlAndBodyFromPetitionPluginDetails < ActiveRecord::Migration
  def change
    remove_column :petition_plugin_details, :document_url
    remove_column :petition_plugin_details, :body
  end
end
