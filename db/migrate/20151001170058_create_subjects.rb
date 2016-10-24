class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.references :plugin_relation, index: true, foreign_key: true

      t.string :title
      t.string :slug
      
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :subjects, :deleted_at
  end
end
