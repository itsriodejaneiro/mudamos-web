module Repository
  extend ActiveSupport::Concern

  def persist(entity)
    entity.save
  end

  def persist!(entity)
    entity.save!
  end
end
