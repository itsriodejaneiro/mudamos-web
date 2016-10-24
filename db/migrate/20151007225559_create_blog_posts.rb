class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.references :plugin_relation, index: true, foreign_key: true
      t.string   :title
      t.text     :content
      t.string   :picture
      t.string   :picture_file_name
      t.string   :picture_content_type
      t.integer  :picture_file_size
      t.datetime :picture_updated_at
      t.boolean  :is_readonly
      t.datetime :release_date
      t.string   :slug
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
