class CreateInternalNotifications < ActiveRecord::Migration
  def change
    create_table :internal_notifications do |t|
      t.integer :notification_id
      t.datetime :read_at
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
