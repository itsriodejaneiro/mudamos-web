module Repository
  extend ActiveSupport::Concern

  class_methods do
    def model_class
      self.to_s.sub(/Repository\z/, "").constantize
    end
  end

  included do
    delegate :model_class, to: :class
  end

  def persist(entity)
    entity.save
  end

  def persist!(entity)
    entity.save!
  end

  def find_by_id!(id)
    model_class.find id
  end
end
