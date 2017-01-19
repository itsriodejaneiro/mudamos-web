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

  class S3

    class CorruptedUpload < StandardError; end

    def upload(bucket, document_name, content, opts)
      original_md5 = md5(content)

      s3 = Aws::S3::Resource.new
      obj = s3.bucket(bucket).object(document_name)

      opts = opts || {}
      opts = opts.merge({ body: content })

      put_object_output = obj.put(opts)

      raise CorruptedUpload unless original_md5 == parse_etag(put_object_output.etag)

      obj
    end

    private

    def md5(content)
      md5 = Digest::MD5.new
      md5.update content

      md5.hexdigest
    end

    def parse_etag(etag)
      etag.gsub(/"(.+)"/, '\1')
    end
  end
end
