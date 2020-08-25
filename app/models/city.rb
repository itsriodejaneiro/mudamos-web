# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  uf         :string(2)
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class City < ActiveRecord::Base
  default_scope { order('name ASC') }

  def self.find_best_match(searched_city, searched_uf = nil)
    cities = searched_uf ? City.where(uf: searched_uf) : City.all
    ranks = searched_city.squeeze.strip.downcase.no_accent.pair_distance_similar(
      cities.map { |city| city.name.downcase.no_accent }
    )
    max_rank = ranks.max
    best_match_index = ranks.index { |r| r == max_rank }
    cities[best_match_index]
  end
end
