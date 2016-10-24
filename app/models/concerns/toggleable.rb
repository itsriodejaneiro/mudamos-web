module Toggleable
  extend ActiveSupport::Concern

  included do
    acts_as_paranoid

    belongs_to :user
    belongs_to :comment, counter_cache: true

    has_many :notifications, as: :target_object, dependent: :destroy

    validates_presence_of :user, :comment

    validates_uniqueness_of :user_id, scope: :comment_id, conditions: -> { where(deleted_at: nil)}, message: 'not available'

    define_method("un#{self.to_s.underscore}") do
      self.destroy
    end

    Comment.column_names.each do |attr|
      define_method "comment_#{attr}" do
        self.comment.send(attr)
      end
    end

    def all_attributes
      super + Comment.column_names.map { |attr| "comment_#{attr}" }
    end
  end
end
