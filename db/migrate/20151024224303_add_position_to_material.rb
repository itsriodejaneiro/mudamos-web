class AddPositionToMaterial < ActiveRecord::Migration
  def change
    add_column :materials, :position, :integer
  end
end
