class AddPlugins < ActiveRecord::Migration
  def up
    bib = Plugin.create(
      name: 'Biblioteca',
      plugin_type: 'Biblioteca',
      can_be_readonly: false
    )

    glo = Plugin.create(
      name: 'Glossário',
      plugin_type: 'Glossário',
      can_be_readonly: false
    )

    begin
      cycle = Cycle.find('seguranca-publica')
    rescue ActiveRecord::RecordNotFound
      puts "Cycle seguranca-publica not found. Skipping."
      return
    end

    PluginRelation.create(
      related: cycle,
      plugin: bib,
      is_readonly: false
    )

    PluginRelation.create(
      related: cycle,
      plugin: glo,
      is_readonly: false
    )
  end

  def down
  end
end
