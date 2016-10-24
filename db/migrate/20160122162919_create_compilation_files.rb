class CreateCompilationFiles < ActiveRecord::Migration
  def change
    create_table :compilation_files do |t|
      t.references :plugin_relation, index: true, foreign_key: true

      t.string :title1, default: "Perfil de Cadastrados na Plataforma"
      t.string :title2, default: "Adesão dos Participantes aos Assuntos"
      t.string :title3, default: "Participação de Anônimos X Identificados"

      t.attachment :file

      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :compilation_files, :deleted_at

    Plugin.where(plugin_type: 'Relatoria').each do |p|
      p.plugin_relations.each do |pr|
        cf = CompilationFile.create(plugin_relation: pr)
        # pr.compilation_file = cf
      end
    end
  end
end
