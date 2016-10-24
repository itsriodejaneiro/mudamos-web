# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  profile_id             :integer
#  birthday               :date
#  picture_file_name      :string
#  picture_content_type   :string
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  alias_as_default       :boolean          default(FALSE)
#  sub_profile_id         :integer
#  gender                 :integer
#  encrypted_name         :string
#  encrypted_cpf          :string
#  encrypted_birthday     :string
#  encrypted_state        :string
#  encrypted_city         :string
#  encrypted_alias_name   :string
#  encrypted_email        :string
#  is_admin               :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Test User#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password "12345678"
    password_confirmation "12345678"
    birthday { Date.new(1990) }
    city 'Rio de Janeiro'
    state 'RJ'
    gender { rand(0..3) }
    first_step false

    alias_as_default false
    sequence(:alias_name) { FactoryGirl.create(:alias_name).name }

    association :profile
    association :sub_profile, factory: :profile

    factory :user_with_valid_sub_profile do
      association :profile, factory: [:profile, :with_children]

      after(:build) do |u|
        sub_prof = u.profile.children.first
        u.sub_profile_id = sub_prof.id
      end
    end

    factory :first_step_user do
      first_step true

      state nil
      city nil
      profile nil
      profile_id nil
      sub_profile nil
      gender nil
    end


    after(:build) do |u|
      name = Faker::Name.name
      AliasName.create(name: name)
      u.alias_name = name
    end
  end

end
