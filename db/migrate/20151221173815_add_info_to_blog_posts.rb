class AddInfoToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :active, :boolean, default: true
    add_column :blog_posts, :highlighted, :boolean, default: false
  end
end
