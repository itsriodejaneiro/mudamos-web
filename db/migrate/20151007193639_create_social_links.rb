class CreateSocialLinks < ActiveRecord::Migration
  def change
    create_table :social_links do |t|
      t.string :provider
      t.string :link
      t.string :icon_class
      t.text :description
      t.references :cycle, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
