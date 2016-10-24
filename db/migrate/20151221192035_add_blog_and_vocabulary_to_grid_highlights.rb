class AddBlogAndVocabularyToGridHighlights < ActiveRecord::Migration
  def change
    add_column :grid_highlights, :blog, :boolean, default: false
    add_column :grid_highlights, :vocabulary, :boolean, default: false
  end
end
