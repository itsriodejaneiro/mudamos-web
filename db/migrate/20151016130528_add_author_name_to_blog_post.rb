class AddAuthorNameToBlogPost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :author_name, :string
  end
end
