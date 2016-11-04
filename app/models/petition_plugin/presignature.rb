# == Schema Information
#
# Table name: petition_plugin_presignatures
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  plugin_relation_id :integer          not null
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class PetitionPlugin::Presignature < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  belongs_to :plugin_relation

  validates :user, presence: true, uniqueness: { scope: :plugin_relation_id }
  validates :plugin_relation, presence: true

  validate :plugin_type_petition

  private

  def plugin_type_petition
    return unless plugin_relation

    plugin_type = PluginTypeRepository::ALL_TYPES[:petition]

    return if plugin_relation.plugin.plugin_type == plugin_type

    errors.add :plugin_relation, :invalid_plugin_type, plugin_type: plugin_type
  end
end
