class AddPluginRelationIdToMaterials < ActiveRecord::Migration
  def change
    add_reference :materials, :plugin_relation, index: true, foreign_key: true

    begin
      cycle = Cycle.find 'seguranca-publica'
    rescue ActiveRecord::RecordNotFound
      puts "Cycle seguranca-publica not found. Skipping."
      return
    end

    pr = cycle.plugin_relations.find_by_slug 'biblioteca'

    unless pr
      puts "'biblioteca' plugin relation not found. Skipping."
      return
    end

    Material.find_each do |m|
      m.update_column(:plugin_relation_id, pr.id)
    end
  end
end
