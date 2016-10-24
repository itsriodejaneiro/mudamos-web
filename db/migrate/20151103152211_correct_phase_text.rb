class CorrectPhaseText < ActiveRecord::Migration
  def change
    phase = Phase.where(name: 'Relatoria',
                        description: 'Organização de todas contribuições em documentos que representarão o debate.'
                        ).first

    if phase
      phase.update_attribute('description', 'Organização das contribuições em documentos que representarão o debate.')
    end

  end
end
