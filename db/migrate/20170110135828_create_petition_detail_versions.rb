class CreatePetitionDetailVersions < ActiveRecord::Migration
  def change
    create_table :petition_plugin_detail_versions do |t|
      t.references :petition_plugin_detail, index: { name: 'idx_petition_plg_detail_versions_on_petition_plg_detail_id' }, foreign_key: { on_delete: :cascade }, null: false
      t.string :document_url, null: false
      t.text :body, null: false
      t.timestamps null: false
      t.datetime :deleted_at, index: true
    end
  end
end
