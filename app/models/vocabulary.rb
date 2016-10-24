# == Schema Information
#
# Table name: vocabularies
#
#  id                 :integer          not null, primary key
#  cycle_id           :integer
#  title              :string
#  first_letter       :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  plugin_relation_id :integer
#

class Vocabulary < ActiveRecord::Base
  default_scope { order('title ASC') }

  include PgSearch

  belongs_to :plugin_relation
  belongs_to :cycle

  pg_search_scope :vocabulary_search,
                  against: [
                    :title,
                    :description
                  ],
                  ignoring: :accents,
                  using: [:tsearch, :trigram]

  validates_presence_of :title, :description
  after_validation :set_first_letter, unless: -> { self.title.blank? }

  private

    def set_first_letter
      self.first_letter = self.title[0].downcase
    end
end
