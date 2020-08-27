class AddRequirAddEmailSentAtInLaiPdfs < ActiveRecord::Migration
  def change
    add_column :lai_pdfs, :email_sent_at, :datetime
  end
end
