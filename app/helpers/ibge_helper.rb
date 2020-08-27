module IbgeHelper
  include UserInput

  def get_all_census
    Rails.cache.fetch("ibge:population:all", expires_in: 24.hours) do
      CSV.read("app/assets/docs/ibge_population.csv", headers: true)
    end
  end

  def get_census_by_uf(uf)
    Rails.cache.fetch("ibge:population:#{uf}", expires_in: 24.hours) do
      get_all_census.delete_if { |row| row["uf"] != uf }
    end
  end

  def find_city_best_match(city:, uf: nil)
    ibge_cities = uf ? get_census_by_uf(uf) : get_all_census
    probabilities = clean_up_name(city).pair_distance_similar(
      ibge_cities.map { |row| clean_up_name(row["name"]) }
    )
    probabilities_with_cities = probabilities.each_with_index.map do |probability, i|
      { city: ibge_cities[i].to_h, probability: probability }
    end
    sorted_probabilities_with_cities = probabilities_with_cities.sort_by { |r| r[:probability] }.reverse
    sorted_probabilities_with_cities[0][:city]
  end
end
