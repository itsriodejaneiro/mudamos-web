class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.integer :cycle_id
      t.string :name
      t.string :description
      t.string :tooltip
      t.datetime :initial_date
      t.datetime :final_date
      t.string :slug
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :phases, :deleted_at
  end
end
