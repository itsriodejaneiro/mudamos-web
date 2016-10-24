# == Schema Information
#
# Table name: plugin_relations
#
#  id           :integer          not null, primary key
#  related_id   :integer
#  related_type :string
#  plugin_id    :integer
#  is_readonly  :boolean
#  read_only_at :datetime
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  slug         :string
#

FactoryGirl.define do
  factory :base_plugin_relation, class: 'PluginRelation' do
    association :plugin
    is_readonly false
    read_only_at "2015-09-02 20:53:59"

    [:phase, :cycle].each do |rel|
      factory "#{rel}_plugin_relation".to_sym do
        association :related, factory: rel
        ['blog', 'discussion', 'compilation', 'static_page'].each do |type|
          factory "#{rel}_#{type}_plugin_relation".to_sym do
            association :plugin , plugin_type: type.camelcase
          end
        end
      end
    end
  end

end
