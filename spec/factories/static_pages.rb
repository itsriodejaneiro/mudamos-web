# == Schema Information
#
# Table name: static_pages
#
#  id             :integer          not null, primary key
#  name           :string
#  title          :string
#  slug           :string
#  cycle_id       :integer
#  content        :text
#  show_on_footer :boolean          default(TRUE)
#  show_on_header :boolean          default(FALSE)
#  deleted_at     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :static_page do
    name "MyString"
cycle nil
content "MyText"
show_on_footer false
show_on_header false
deleted_at "2016-01-14 14:00:11"
  end

end
