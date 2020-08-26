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

        # IBGE population api accept pass multiple city_id in patch separating with "|"
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

  desc "Update table cities"
  task set_in_database: :environment do
    ibge_cities = CSV.read("app/assets/docs/ibge_population.csv", headers: true)

    # blacklist is an array containing all cities that hasn't a obvious match or
    # aren't even found in our database comparing to IBGE cities
    blacklist = [
      'Januário Cicco',
      'Joca Claudino',
      'Tacima',
      'Embu das Artes',
      'Quarto Centenário',
      'Balneário Rincão'
    ]

    success = 0
    failues = 0
    total = 0

    ibge_cities.delete_if { |row| blacklist.include? row["name"] }.each do |ibge_city|
      ibge_city_name = ibge_city["name"]
      ibge_city_uf = ibge_city["uf"]
      ibge_city_name_and_uf =  "#{ibge_city["name"]}/#{ibge_city["uf"]}"

      city = City.find_by(ibge_id: ibge_city["id"])
      city = City.find_best_match(ibge_city_name, ibge_city_uf) if city.nil?

      city_name_and_uf =  "#{city.name}/#{city.uf}"

      if ibge_city_name_and_uf != city_name_and_uf
        puts "#{ibge_city_name_and_uf} !== #{city_name_and_uf}"
        failues += 1
      else
        success += 1
      end

      city.population = ibge_city["population"];
      city.ibge_id = ibge_city["id"];
      city.save!

      total += 1
    end

    puts '----------------------------------'
    puts "    perfect match #{success}/#{total}"
    puts "not perfect match #{failues}/#{total}"
  end
end
