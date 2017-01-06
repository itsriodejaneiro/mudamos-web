class AddPluginRelationToVocabularies < ActiveRecord::Migration
  def change
    add_reference :vocabularies, :plugin_relation, index: true, foreign_key: true

    cycle = Cycle.find_by_slug 'seguranca-publica'
    unless cycle
      puts "Cycle seguranca-publica not found. Skipping"
      return
    end

    id = cycle.plugin_relations.find_by_slug('glossario').try(:id)

    unless id
      puts "'glossario' plugin relation not found. Skipping"
      return
    end

    Vocabulary.find_each do |v|
      v.update_column(:plugin_relation_id, id)
    end
  end
end
