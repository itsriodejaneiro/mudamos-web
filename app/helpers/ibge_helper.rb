module IbgeHelper
  def get_population
    CSV.read("app/assets/docs/ibge_population.csv", headers: true)
  end

  def find_city_best_match(city:, uf: nil)
    ibge_cities = uf ? get_population.delete_if { |row| row["uf"] != uf } : get_population
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
