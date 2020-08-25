class CreateLaiPdfs < ActiveRecord::Migration
  def change
    create_table :lai_pdfs do |t|
      t.json :request_payload, null: false
      t.uuid :pdf_id,          null: false
      t.string :pdf_url
      t.references :city,      index: true, foreign_key: true
      t.timestamps             null: false
    end
  end
end
