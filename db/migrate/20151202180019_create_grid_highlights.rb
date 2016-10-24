class CreateGridHighlights < ActiveRecord::Migration
  def change
    create_table :grid_highlights do |t|
      t.references :target_object, :polymorphic => true

      t.timestamps null: false
    end
    add_index :grid_highlights, :target_object_id
  end
end
