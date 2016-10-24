class AddPictureToSettings < ActiveRecord::Migration
  def change
    add_attachment :settings, :picture
  end
end
