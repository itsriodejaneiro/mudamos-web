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
