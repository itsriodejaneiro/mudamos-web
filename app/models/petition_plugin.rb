module PetitionPlugin
  def self.table_name_prefix
    'petition_plugin_'
  end

  private

  def plugin_type_petition
    return unless plugin_relation

    plugin_type = PluginTypeRepository::ALL_TYPES[:petition]

    return if plugin_relation.plugin.plugin_type == plugin_type

    errors.add :plugin_relation, :invalid_plugin_type, plugin_type: plugin_type
  end
end
