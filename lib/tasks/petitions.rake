namespace :petitions do
  desc "Publishes a petition"
  task :publish, [:version_id] => :environment do |_, args|
    version_id = args[:version_id]

    sqs_service = AwsService::SQS.new
    sqs_service.publish_message(Rails.application.secrets.queues['petition_publisher'], id: version_id)

    puts "Version: #{version_id} scheduled for publication"
  end

  desc "Fetches petitions informations from the api and store it on the cache"
  task fetch_info: :environment do |_, args|

    log = -> message {
      puts message
      Rails.logger.info message
    }

    error = -> message {
      puts message
      Rails.logger.error message
    }

    petition_service = PetitionService.new

    PetitionPlugin::Detail.all.find_in_batches do |batch|
      batch.each do |detail|
        begin
          petition_service.fetch_petition_info detail.id, fresh: true
          log.call "Fetched information for petition #{detail.id}"
        rescue => error
          error.call "Could not fetch information for petition #{detail.id}"
          error.call error
        end
      end
    end
  end
end
