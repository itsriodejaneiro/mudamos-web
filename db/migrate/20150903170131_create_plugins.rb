class CreatePlugins < ActiveRecord::Migration
  def change
    create_table :plugins do |t|
      t.string :name
      t.string :plugin_type
      t.boolean :can_be_readonly
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :plugins, :deleted_at
  end
end
