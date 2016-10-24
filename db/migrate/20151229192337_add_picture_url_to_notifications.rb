class AddPictureUrlToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :picture_url, :string
  end
end
