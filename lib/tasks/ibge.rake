namespace :ibge do
  desc "Get cities from IBGE"
  task :get_cities do
    ibge_cities_response = Faraday.get ENV["IBGE_CITIES_LIST_URL"]
    ibge_cities_json = JSON.parse(ibge_cities_response.body)

    CSV.open("app/assets/docs/ibge_cities.csv", "wb", headers: true) do |csv|
      csv << ["id", "name", "uf"]
      ibge_cities_json.each do |city|
        city_id = city["id"]
        city_name = city["nome"]
        city_uf = city["microrregiao"]["mesorregiao"]["UF"]["sigla"]

        csv << [city_id, city_name, city_uf]
      end
    end
  end

  desc "Get population from IBGE"
  task :get_population do
    cities = CSV.read("app/assets/docs/ibge_cities.csv", headers: true)
    batch = 100

    CSV.open("app/assets/docs/ibge_population.csv", "wb", headers: true) do |csv|
      csv << ["id", "name", "uf", "population"]

      cities.map(&:to_h).in_groups_of(batch, false) do |batch_cities|
        cities_id = batch_cities.map { |city| city["id"] }

        # IBGE population api accepts multiple city_id in patch separating with "|"
        # Since "|" character is not valid to URI, we used the correspondent URI caracter ("%7C")
        population_response = Faraday.get "#{ENV["IBGE_CITIES_POPULATION_URL"]}#{cities_id.join("%7C")}"
        population_json = JSON.parse(population_response.body)
        population_formatted = population_json[0]["res"].map { |x| x["res"][x["res"].keys.max] }

        batch_cities.each.with_index do |city, index|
          id = city["id"]
          name = city["name"]
          uf = city["uf"]
          population = population_formatted[index]

          csv << [id, name, uf, population]
        end
      end
    end
  end
end
