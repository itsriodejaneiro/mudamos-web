class CreatePushNotifications < ActiveRecord::Migration
  def change
    create_table :push_notifications do |t|
      t.integer :notification_id
      t.datetime :sent_at
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
