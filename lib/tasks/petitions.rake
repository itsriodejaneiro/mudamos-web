namespace :petitions do
  desc "Publishes a petition"
  task :publish, [:version_id] => :environment do |_, args|
    version_id = args[:version_id]

    sqs_service = AwsService::SQS.new
    sqs_service.publish_message(Rails.application.secrets.queues['petition_publisher'], id: version_id)

    puts "Version: #{version_id} scheduled for publication"
  end
end
