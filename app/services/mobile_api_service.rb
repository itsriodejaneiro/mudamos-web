class MobileApiService

  class RequestError < StandardError; end
  class InvalidRequest < RequestError; end

  class ValidationError < RequestError
    attr_accessor :validations

    def initialize(message, validations)
      super(message)
      @validations = validations
    end

    def to_s
      "#{super} #{validations}"
    end
  end

  attr_accessor :mobile_api_secret

  def initialize(
    url: Rails.application.secrets.apis['mobile']['url'],
    mobile_api_secret: Rails.application.secrets.apis['mobile']['secret'],
    timeout: Rails.application.secrets.apis['mobile']['timeout'],
    logger: Rails.logger
  )

    raise ArgumentError, "You must inform the mobile API URL" unless url

    @url = url
    @mobile_api_secret = mobile_api_secret
    @logger = logger
    @timeout = timeout
  end

  def register_petition_version(petition_detail_version)
    phase = petition_detail_version.petition_plugin_detail.plugin_relation.related

    page_url = Rails.application.routes.url_helpers.cycle_plugin_relation_url(
      phase.cycle,
      phase.plugin_relation
    )

    headers = authorization_header

    post("/api/v1/petition/register", {
      petition: {
        id_petition: petition_detail_version.petition_plugin_detail_id,
        id_version: petition_detail_version.id,
        name: phase.name,
        url: petition_detail_version.document_url,
        page_url: page_url,
        sha: petition_detail_version.sha
      },
    }, headers)
  end

  PetitionInfo = Struct.new(:updated_at, :signatures_count, :blockchain_address)
  def petition_info(petition_id)
    response = get("/api/v1/petition/plip/#{petition_id}/info")

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
    response = get("/api/v1/petition/#{version_id}/#{limit}/votes")

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

  SignatureStatus = Struct.new(:petition_name, :petition_page_url, :blockchain_updated_at, :updated_at, :user_name, :signatures_pdf_url)
  def signature_status(signature)
    response = post("/api/v1/message/blockchain/status", sign: { signature: signature })

    sign = JSON.parse(response.body)["data"]["sign"]

    status = SignatureStatus.new(
      sign["petition_name"],
      sign["petition_page_url"],
      sign["blockchain_updatedat"].present? ? Time.parse(sign["blockchain_updatedat"]) : nil,
      sign["updatedat"].present? ? Time.parse(sign["updatedat"]) : nil,
      sign["user_name"],
      sign["signatures_pdf_url"]
    )

    status
  rescue ValidationError => e
    Rails.logger.info e
    nil
  end

  PetitionSignature = Struct.new(:pdf_url, :blockchain_transaction_id, :updated_at, :transaction_date, :blockstamp, :signature)
  def petition_signatures(petition_id)
    response = get("/api/v1/petition/#{petition_id}/signatures")

    signatures_json = JSON.parse(response.body)["data"]["signatures"]

    signatures_json.map do |json|
      PetitionSignature.new(
         json["petition_pdf_url"],
         json["petition_blockchain_transaction_id"],
         json["petition_updatedat"] ? Time.parse(json["petition_updatedat"]) : nil,
         json["petition_txstamp"] ? Time.parse(json["petition_txstamp"]) : nil,
         json["petition_blockstamp"] ? Time.parse(json["petition_blockstamp"]) : nil,
         json["petition_signature"]
      )
    end
  end

  PetitionStatus = Struct.new(:status, :blockstamp, :transaction, :transaction_date)
  def petition_status(sha)
    response = get("/api/v1/petition/#{sha}/status")

    blockchain_info = JSON.parse(response.body)["data"]["blockchain"]
    return nil unless blockchain_info

    PetitionStatus.new(
      blockchain_info["status"],
      blockchain_info["blockstamp"] ? Time.parse(blockchain_info["blockstamp"]) : nil,
      blockchain_info["transaction"],
      blockchain_info["txstamp"] ? Time.parse(blockchain_info["txstamp"]) : nil
    )
  end

  private

  [:get, :head].each do |verb|
    define_method(verb) do |path, headers = nil|
      body = connection.send(verb, path) do |req|
        req.options.timeout = @timeout if @timeout
        req.headers.merge! headers if headers
      end

      validate_response body

      body
    end
  end

  [:put, :post].each do |verb|
    define_method(verb) do |path, body, headers = nil|
      body = connection.send(verb) do |req|
        req.url path
        req.body = JSON.generate(body) if body
        req.options.timeout = @timeout if @timeout

        req.headers["Content-Type"] = "application/json"
        req.headers.merge! headers if headers
      end

      validate_response body

      body
    end
  end

  def authorization_header
    { "Authorization" => mobile_api_secret }
  end

  def validate_response(response)
    fail RequestError.new("Got #{response.status} from #{response.env.url}") unless response.status >= 200 && response.status <= 299

    body = JSON.parse(response.body)

    if body["status"] == "fail"
      data = body["data"]

      fail ValidationError.new("Request returned with validation errors", data["validations"]) if data["errorCode"].present?
    end

    fail InvalidRequest.new("Request failed with errors: #{body["data"]}") unless body["status"] == "success"
  end

  def connection
    @connection ||= Faraday.new(:url => @url) do |connection|
      connection.response :logger, @logger
      connection.adapter Faraday.default_adapter
    end
  end
end
