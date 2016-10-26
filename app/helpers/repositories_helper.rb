module RepositoriesHelper
  def plugin_repository
    @plugin_repository ||= PluginRepository.new
  end
end
