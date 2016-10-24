class AddCycleToMaterials < ActiveRecord::Migration
  def change
    add_reference :materials, :cycle, index: true, foreign_key: true
  end
end
