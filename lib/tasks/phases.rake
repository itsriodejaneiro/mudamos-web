namespace :phases do
  desc "Sets the final date of the phase to the end of the day"
  task ends_on_the_end_of_the_day: :environment do |_, args|
    Phase.all.find_in_batches do |batch|
      batch.each do |phase|
        phase.update final_date: phase.final_date.end_of_day
      end
    end
  end
end
