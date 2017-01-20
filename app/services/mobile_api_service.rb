class MobileApiService

  class RequestError < StandardError; end
  class InvalidRequest < RequestError; end

  def initialize(
    url: Rails.application.secrets.apis['mobile']['url'],
    timeout: Rails.application.secrets.apis['mobile']['timeout'],
    logger: Rails.logger
  )

    raise ArgumentError, "You must inform the mobile API URL" unless url

    @url = url
    @logger = logger
    @timeout = timeout
  end

  def register_petition_version(petition_detail_version)
    post("/petition/register", petition: {
      id_petition: petition_detail_version.petition_plugin_detail_id,
      id_version: petition_detail_version.id,
      url: petition_detail_version.document_url,
      sha: petition_detail_version.sha
    })
  end

  PetitionInfo = Struct.new(:updated_at, :signatures_count, :blockchain_address)
  def petition_info(petition_id)
    response = get("/petition/#{petition_id}/info")

    body = JSON.parse(response.body)["data"]["info"]

    return nil unless body

    PetitionInfo.new(
      Time.parse(body["updatedAt"]),
      body["signaturesCount"],
      body["blockchainAddress"]
    )
  end

  private

  [:get, :head].each do |verb|
    define_method(verb) do |path|
      body = connection.send(verb, path) do |req|
        req.options.timeout = @timeout if @timeout
      end

      validate_response body

      body
    end
  end

  [:put, :post].each do |verb|
    define_method(verb) do |path, body|
      body = connection.send(verb) do |req|
        req.url path
        req.headers["Content-Type"] = "application/json"
        req.body = JSON.generate(body) if body
        req.options.timeout = @timeout if @timeout
      end

      validate_response body

      body
    end
  end

  def validate_response(response)
    fail RequestError.new("Got #{response.status} from #{response.env.url}") unless response.status >= 200 && response.status <= 299

    body = JSON.parse(response.body)
    fail InvalidRequest.new("Request failed with errors: #{body["data"]}") unless body["status"] == "success"
  end

  def connection
    @connection ||= Faraday.new(:url => @url) do |connection|
      connection.response :logger, @logger
      connection.adapter :net_http_persistent
    end
  end
end
