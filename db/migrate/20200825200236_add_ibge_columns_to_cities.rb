class AddIbgeColumnsToCities < ActiveRecord::Migration
  def change
    add_column :cities, :ibge_id, :string
    add_column :cities, :population, :integer
  end
end
