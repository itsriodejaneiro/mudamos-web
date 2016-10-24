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

class Plugin < ActiveRecord::Base
  acts_as_paranoid
  has_many :plugin_relations, dependent: :destroy
  has_many :permissions, as: :target, dependent: :destroy

  validates_presence_of :name, :plugin_type

  def self.plugin_types
    ['Discussão', 'Blog', 'Relatoria', 'Biblioteca', 'Glossário']
  end
end
