class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :comment, index: true, foreign_key: true
      
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
