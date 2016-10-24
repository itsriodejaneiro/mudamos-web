class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :target_user_id
      t.string :target_user_type
      t.integer :target_object_id
      t.string :target_object_type
      t.text :title
      t.text :description
      t.string :view_url
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
