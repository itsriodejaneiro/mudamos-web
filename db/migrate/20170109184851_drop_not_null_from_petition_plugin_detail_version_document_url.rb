class DropNotNullFromPetitionPluginDetailVersionDocumentUrl < ActiveRecord::Migration
  def change
    change_column :petition_plugin_detail_versions, :document_url, :string, null: true
  end
end
