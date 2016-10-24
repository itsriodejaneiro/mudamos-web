class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string   "name"
      t.string   "uf",         :limit => 2
      t.integer  "status",     :default => 0
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
