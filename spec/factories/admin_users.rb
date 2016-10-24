# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  password               :string
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  admin_type             :integer          default(0)
#

FactoryGirl.define do
  factory :admin_users do
    sequence(:name) { |n| "Test Admin User#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password "12345678"
    password_confirmation "12345678"
  end
end
