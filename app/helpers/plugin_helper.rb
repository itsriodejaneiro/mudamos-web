module PluginHelper
  def link_to_plugin_page(phase)
    return unless phase.initial_date < Time.current

    path = case phase.plugin.plugin_type
    when 'Relatoria', 'Petição'
      cycle_plugin_relation_path(phase.cycle, phase.plugin_relation)
    when 'Discussão'
      [phase.cycle, :subjects]
    else
      return
    end

    link_to 'Saiba mais', path, style: "color: #{phase.cycle.color}"
  end
end
