class AddQuestionToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :question, :text
  end
end
