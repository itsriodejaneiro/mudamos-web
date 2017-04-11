class CreatePetitionPluginApprovers < ActiveRecord::Migration
  def change
    create_table :petition_plugin_approvers do |t|
      t.string :email, null: false
      t.references :plugin_relation, index: true, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps null: false
    end

    add_index :petition_plugin_approvers, %i(email plugin_relation_id), name: :index_petition_approvers, unique: true
  end
end
