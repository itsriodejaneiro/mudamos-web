class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :target_id
      t.string :target_type
      t.boolean :can_manage_users
      t.boolean :can_view
      t.boolean :can_create
      t.boolean :can_update
      t.boolean :can_delete
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :permissions, :deleted_at
  end
end
