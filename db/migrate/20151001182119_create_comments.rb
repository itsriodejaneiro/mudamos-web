class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :subject, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.text :content
      
      t.boolean :was_intermediated, default: false

      t.boolean :should_show_alias
      
      t.integer :parent_id, null: true, index: true
      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true
      t.integer :depth, null: false, default: 0
      
      t.integer :children_count, null: false, default: 0
      t.integer :likes_count, null: false, default: 0
      t.integer :dislikes_count, null: false, default: 0
      t.integer :reports_count, null: false, default: 0
      t.integer :comment_versions_count, null: false, default: 0
      
      t.string :slug
      
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :comments, :deleted_at
  end
end
