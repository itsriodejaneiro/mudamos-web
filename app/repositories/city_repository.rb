class CityRepository
  include Repository
  include UserInput

  def find_best_match(searched_city, searched_uf = nil)
    City.find_best_match(searched_city, searched_uf)
  end
end
