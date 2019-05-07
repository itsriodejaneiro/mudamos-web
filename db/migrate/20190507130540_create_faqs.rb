class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.boolean :published, default: true
      t.references :user, index: true, foreign_key: true

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
