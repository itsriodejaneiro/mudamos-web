class AddPictureToCycle < ActiveRecord::Migration
  def change
    add_attachment :cycles, :picture
  end
end
