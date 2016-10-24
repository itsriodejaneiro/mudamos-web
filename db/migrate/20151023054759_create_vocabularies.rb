class CreateVocabularies < ActiveRecord::Migration
  def change
    create_table :vocabularies do |t|
      t.references :cycle, index: true, foreign_key: true
      t.string :title
      t.string :first_letter
      t.text :description

      t.timestamps null: false
    end
  end
end
