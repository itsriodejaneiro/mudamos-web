class CreatePluginRelations < ActiveRecord::Migration
  def change
    create_table :plugin_relations do |t|
      t.references :related, polymorphic: true, index: true

      t.integer :plugin_id
      
      t.boolean :is_readonly
      t.datetime :read_only_at
      
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :plugin_relations, :deleted_at
  end
end
