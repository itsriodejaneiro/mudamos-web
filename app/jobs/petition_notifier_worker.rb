class PetitionNotifierWorker
  include Shoryuken::Worker
  shoryuken_options queue: Rails.application.secrets.queues['petition_notifier'], auto_delete: true

  attr_reader :repository
  attr_accessor :push_message_service

  def initialize(
    repository: PetitionPlugin::DetailVersionRepository.new,
    push_message_service: PushMessageService.new
  )
    @repository = repository
    @push_message_service = push_message_service
  end

  def perform(sqs_msg, body)
    petition_detail_version_id = JSON.parse(body)['id']
    version = repository.find_by_id petition_detail_version_id

    if version
      push version
      Rails.logger.info "Push message sent for petition detail version: #{petition_detail_version_id}"
    else
      Rails.logger.warn "Version not found #{petition_detail_version_id}"
    end
  end

  def push(version)
    phase = version.petition_plugin_detail.plugin_relation.related
    heading = "Novo projeto de lei"
    content = %{Olá, um novo projeto de lei "#{phase.name}" já está disponível. Participe!}

    push_message_service.deliver headings: { en: heading }, contents: { en: content }
  end
end
