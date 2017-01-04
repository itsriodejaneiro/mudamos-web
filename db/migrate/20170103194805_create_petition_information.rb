class CreatePetitionInformation < ActiveRecord::Migration
  def change
    create_table :petition_plugin_information do |t|
      t.references :plugin_relation, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.datetime :deleted_at, index: true
      t.timestamps null: false
      t.string :call_to_action, null: false
      t.integer :signatures_required, null: false
      t.string :presentation, null: false
      t.string :document_url, null: false
      t.text :body, null: false
    end
  end
end
