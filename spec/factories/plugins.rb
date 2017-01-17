# == Schema Information
#
# Table name: plugins
#
#  id              :integer          not null, primary key
#  name            :string
#  plugin_type     :string
#  can_be_readonly :boolean
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  icon_class      :string
#

FactoryGirl.define do
  factory :plugin do
    name "MyString"
    plugin_type "MyString"
    can_be_readonly false
    icon_class 'discussion'

    trait :report do
      name "Relatoria"
      plugin_type "Relatoria"
    end

    trait :petition do
      name "Petição"
      plugin_type "Petição"
    end

    trait :discussion do
      name "Discussão"
      plugin_type "Discussão"
    end

    trait :blog do
      name "Blog"
      plugin_type "Blog"
    end
  end
end
