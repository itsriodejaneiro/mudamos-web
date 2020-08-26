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

  def self.find_best_match(city:, uf: nil)
    self.find_best_matches(city: city, uf: uf, max_results: 1)[:city]
  end

  def self.find_best_matches(city:, uf: nil, max_results: 1)
    cities = uf ? City.where(uf: uf) : City.all
    probabilities = city.squeeze.strip.downcase.no_accent.pair_distance_similar(
      cities.map { |city| city.name.downcase.no_accent }
    )
    probabilities_with_cities = probabilities.each_with_index.map do |probability, i|
      { city: cities[i], probability: probability }
    end
    sorted_probabilities_with_cities = probabilities_with_cities.sort_by { |r| r[:probability] }.reverse

    if max_results == 1
      sorted_probabilities_with_cities[0]
    else
      sorted_probabilities_with_cities.first(max_results)
    end
  end
end
