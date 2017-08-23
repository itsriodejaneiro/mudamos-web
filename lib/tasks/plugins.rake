namespace :plugins do
  desc "Syncs all plugins using the fixture"
  task sync: :environment do
    repository = PluginRepository.new
    fixtures = YAML::load_file(Rails.root.join "db", "fixtures", "plugins.yml").deep_symbolize_keys

    fixtures[:plugins].each do |fixture|
      plugin = repository.find_by_name(fixture[:name]) || Plugin.new
      plugin.attributes = fixture

      repository.persist! plugin

      puts "Plugin: #{plugin.name} synced"
    end
  end
end
