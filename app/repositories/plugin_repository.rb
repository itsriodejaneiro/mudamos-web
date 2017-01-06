class PluginRepository
  include Repository

  attr_accessor :plugin_type_repository

  def initialize(plugin_type_repository: PluginTypeRepository.new)
    @plugin_type_repository = plugin_type_repository
  end

  def all_with_phases
    Plugin.where(plugin_type: plugin_type_repository.available_types_with_phases)
  end

  def all_without_phases
    Plugin.where(plugin_type: plugin_type_repository.available_types_without_phases)
  end

  def find_by_name(name)
    Plugin.find_by_name name
  end
end
