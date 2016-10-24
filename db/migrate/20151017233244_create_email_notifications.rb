class CreateEmailNotifications < ActiveRecord::Migration
  def change
    create_table :email_notifications do |t|
      t.integer :notification_id
      t.string :to_email
      t.string :from_email
      t.text :subject
      t.text :content
      t.datetime :sent_at
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
