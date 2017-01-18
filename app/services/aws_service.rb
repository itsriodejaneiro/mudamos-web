module AwsService
  class SQS
    def publish_message(queue_name, payload)
      sqs = Aws::SQS::Client.new

      queue_url = sqs.get_queue_url(queue_name: queue_name)
      sqs.send_message(
        queue_url: queue_url.queue_url,
        message_body: JSON.generate(payload)
      )
    end
  end
end
