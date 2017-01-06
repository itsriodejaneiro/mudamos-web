class CreatePetitionDetailVersions < ActiveRecord::Migration
  def change
    rename_table :petition_plugin_information, :petition_plugin_details

    create_table :petition_plugin_detail_versions do |t|
      t.references :petition_plugin_detail, index: { name: 'idx_petition_plg_detail_versions_on_petition_plg_detail_id' }, foreign_key: { on_delete: :cascade }, null: false
      t.string :document_url, null: false
      t.text :body, null: false
      t.timestamps null: false
      t.datetime :deleted_at, index: true
    end

    remove_column :petition_plugin_details, :document_url
    remove_column :petition_plugin_details, :body
  end
end
