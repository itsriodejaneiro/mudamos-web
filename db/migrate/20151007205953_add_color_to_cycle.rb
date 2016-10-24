class AddColorToCycle < ActiveRecord::Migration
  def change
    add_column :cycles, :color, :string
    add_column :cycles, :description, :string
  end
end
