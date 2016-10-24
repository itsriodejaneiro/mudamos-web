class RenameTitleToEnunciationInSubjects < ActiveRecord::Migration
  def change
    rename_column :subjects, :title, :enunciation
  end
end
