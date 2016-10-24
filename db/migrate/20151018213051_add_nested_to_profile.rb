class AddNestedToProfile < ActiveRecord::Migration
  def change
    change_table :profiles do |t|
      t.integer :parent_id, null: true, index: true
      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true
      t.integer :depth, null: false, default: 0

      t.integer :children_count, null: false, default: 0
    end
  end
end
