class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :published, default: true
      t.integer :sequence
      t.references :admin_user, index: true, foreign_key: true

      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
