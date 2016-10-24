class AddVocabularyInfoToSubjects < ActiveRecord::Migration
  def change
    add_reference :subjects, :vocabulary, index: true, foreign_key: true
    add_column :subjects, :tag_description, :text
  end
end
