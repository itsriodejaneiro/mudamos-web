class CreatePetitionPluginPresignatures < ActiveRecord::Migration
  def change
    create_table :petition_plugin_presignatures do |t|
      t.references :user, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.references :plugin_relation, index: true, foreign_key: { on_delete: :cascade }, null: false

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    add_index :petition_plugin_presignatures, %i(user_id plugin_relation_id), name: :index_presignatures_plugin_and_users
  end
end
