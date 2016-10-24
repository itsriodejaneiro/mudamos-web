class AddPluginRelationToVocabularies < ActiveRecord::Migration
  def change
    add_reference :vocabularies, :plugin_relation, index: true, foreign_key: true

    cycle = Cycle.find_by_slug 'seguranca-publica'
    id = cycle.plugin_relations.find_by_slug('glossario').id

    Vocabulary.find_each do |v|
      v.update_column(:plugin_relation_id, id)
    end
  end
end
