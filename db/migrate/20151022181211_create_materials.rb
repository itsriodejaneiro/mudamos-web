class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :author
      t.string :title
      t.string :source
      t.datetime :publishing_date
      t.string :category
      t.string :external_link
      t.string :themes
      t.string :keywords
      t.string :description

      t.timestamps null: false
    end
  end
end
