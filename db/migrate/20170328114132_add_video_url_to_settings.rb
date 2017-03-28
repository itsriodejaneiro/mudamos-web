class AddVideoUrlToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :video_url, :string
  end
end
