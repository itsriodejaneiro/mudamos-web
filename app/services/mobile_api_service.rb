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
    phase = petition_detail_version.petition_plugin_detail.plugin_relation.related

    page_url = Rails.application.routes.url_helpers.cycle_plugin_relation_url(
      phase.cycle,
      phase.plugin_relation
    )

    post("/petition/register", petition: {
      id_petition: petition_detail_version.petition_plugin_detail_id,
      id_version: petition_detail_version.id,
      url: petition_detail_version.document_url,
      page_url: page_url,
      sha: petition_detail_version.sha
    })
  end

  PetitionInfo = Struct.new(:updated_at, :signatures_count, :blockchain_address)
  def petition_info(petition_id)
    response = get("/petition/#{petition_id}/info")

    body = JSON.parse(response.body)["data"]["info"]

    return nil unless body

    PetitionInfo.new(
      body["updatedAt"].present? ? Time.parse(body["updatedAt"]) : nil,
      body["signaturesCount"],
      body["blockchainAddress"]
    )
  end

  PetitionSigner = Struct.new(:date, :name, :city, :state, :uf, :profile_type, :profile_id, :profile_email, :profile_picture)
  def petition_version_signers(version_id, limit)
    response = get("/petition/#{version_id}/#{limit}/votes")

    signers_json = JSON.parse(response.body)["data"]["votes"]
    return [] unless signers_json

    signers = []
    signers_json.each do |signer|
      signers << PetitionSigner.new(
        Time.parse(signer["vote_date"]),
        signer["user_name"],
        signer["user_city"],
        signer["user_state"],
        signer["user_uf"],
        signer["profile_type"],
        signer["profile_id"],
        signer["profile_email"],
        signer["profile_picture"]
      )
    end

    signers
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
