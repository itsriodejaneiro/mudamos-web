class PluginTypeRepository
  include Repository

  ALL_TYPES = {
    discussion: "Discussão",
    blog: "Blog",
    report: "Relatoria",
    biblioteca: "Biblioteca",
    glossary: "Glossário",
    petition: "Petição"
  }.freeze

  def available_types
    ALL_TYPES.values
  end

  def available_types_with_phases
    ALL_TYPES.select { |k| %i(discussion report petition).include? k }.values
  end

  def available_types_without_phases
    with_phases = available_types_with_phases
    ALL_TYPES.reject { |_, v| with_phases.include? v }.values
  end

  def get_plugin_type(plugin_type)
    case plugin_type
    when "Discussão" then PluginType::Discussion.new
    when "Blog" then PluginType::Blog.new
    when "Relatoria" then PluginType::Report.new
    when "Biblioteca" then PluginType::Library.new
    when "Glossário" then PluginType::Glossary.new
    when "Petição" then PluginType::Petition.new
    end
  end
end
