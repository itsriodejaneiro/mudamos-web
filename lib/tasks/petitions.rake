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
        rescue => e
          error.call "Could not fetch information for petition #{detail.id}"
          error.call e
        end
      end
    end
  end

  desc "Fetches petitions signers from the api and store it on the cache"
  task :fetch_signers, [:size] => :environment do |_, args|
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
          petition_service.fetch_petition_signers detail.id, args[:size], fresh: true
          log.call "Fetched signers for petition #{detail.id}"
        rescue => e
          error.call "Could not fetch signers for petition #{detail.id}"
          error.call e
        end
      end
    end
  end

  desc "Fetches petitions past versions from the api and store it on the cache"
  task past_versions: :environment do
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
          petition_service.fetch_past_versions detail.id, fresh: true
          log.call "Fetched past versions for petition #{detail.id}"
        rescue => e
          error.call "Could not fetch past versions for petition #{detail.id}"
          error.call e
        end
      end
    end
  end

  desc "Fetches petitions pdf signatures and update the cache"
  task fetch_petition_pdf_signatures: :environment do
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
          petition_service.fetch_petition_signatures detail.id, fresh: true
          log.call "Fetched pdf signatures for petition #{detail.id}"
        rescue => e
          error.call "Could not fetch pdf signatures for petition #{detail.id}"
          error.call e
        end
      end
    end
  end

  desc "Generate all (or the given id) current plip pdf covers"
  task :generate_covers, [:plip_id] => :environment do |_, args|
    log = -> message {
      puts message
      Rails.logger.info message
    }

    error = -> message {
      puts message
      Rails.logger.error message
    }

    plip_id = args[:plip_id]

    plips = -> &block {
      if plip_id
        Array.wrap(PetitionPlugin::Detail.find(plip_id)).tap(&block)
      else
        PetitionPlugin::Detail.all.find_in_batches(&block)
      end
    }

    plips.call do |batch|
      batch.each do |detail|
        begin
          log.call "Scheduling cover for plip id: #{detail.id}"
          version = detail.current_version

          PetitionCoverGeneratorWorker.perform_async id: version.id
        rescue => e
          error.call "Error scheduling cover generation for plip: #{detail.id}"
          error.call e
        end
      end
    end
  end

  desc "Generate app link for all petitions"
  task generate_share_links: :environment do
    log = -> message {
      puts message
      Rails.logger.info message
    }

    error = -> message {
      puts message
      Rails.logger.error message
    }

    PetitionPlugin::Detail.where(share_link: nil).map do |petition_detail|
      begin
        log.call "Generating share link for petition: #{petition_detail.id}"
        PetitionShareLinkGenerationWorker.perform_async id: petition_detail.id
      rescue => e
        error.call "Error generating share link for petition: #{petition_detail.id}"
        error.call e
      end
    end
  end
end
