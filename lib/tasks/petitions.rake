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

    petition_cached_service = PetitionCachedService.new

    PetitionPlugin::Detail.all.each do |detail|
      begin
        petition_cached_service.fetch_petition_info detail.id
        puts "Fetched information for petition #{detail.id}"
      rescue => error
        puts "Could not fetch information for petition #{detail.id}"
        puts error
      end
    end
  end
end
