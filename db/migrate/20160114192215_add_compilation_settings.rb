class AddCompilationSettings < ActiveRecord::Migration
  def change
    plugin = Plugin.where(plugin_type: 'Relatoria').first
    phase = Cycle.find('seguranca-publica').phases.find 2

    plugin_relation = PluginRelation.where(plugin: plugin, related: phase).first

    [
      'Perfil de Cadastrados na Plataforma',
      'Adesão dos Participantes aos Assuntos',
      'Participação de Anônimos X Identificados'
    ].each_with_index do |title, i|
      Setting.create(
        key: "cycle_#{plugin_relation.id}_compilation_title_#{i + 1}",
        value: title
      )
    end

    # Setting.create(
    #   key: "cycle_#{1}_compilation_pdf",

    # )
  end
end
