namespace :compilation do
  task update_charts: :environment do
    Cycle.find_each do |c|
      ChartableCache.clear_cache c
      ChartableCache.set_cache c.initial_date, c.final_date, c
    end
  end
end
