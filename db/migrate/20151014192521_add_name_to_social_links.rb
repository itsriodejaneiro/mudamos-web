class AddNameToSocialLinks < ActiveRecord::Migration
  def change
    add_column :social_links, :name, :string
  end
end
