class AddAttachmentPictureToPhases < ActiveRecord::Migration
  def self.up
    change_table :phases do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :phases, :picture
  end
end
