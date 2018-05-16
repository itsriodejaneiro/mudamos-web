class ShareLinkMetricsService

  class RequestError < StandardError; end

  def initialize(
    timeout: Rails.application.secrets.apis['mobile']['timeout'],
    url: "https://www.googleapis.com/auth/firebase",
    logger: Rails.logger
  )

    @timeout = timeout
    @url = url
    @logger = logger
  end

  attr_accessor :timeout
  attr_reader :url
  attr_reader :logger

  def connection
    @connection ||= Faraday.new(:url => url) do |connection|
      connection.response :logger, logger
      connection.adapter Faraday.default_adapter
    end
  end

  def getMetrics(share_link, days)
    share_link_addressable = CGI.escape(share_link)
    headers = authorization_header
    response = get("https://firebasedynamiclinks.googleapis.com/v1/#{share_link_addressable}/linkStats?durationDays=7", headers)
    JSON.parse(response.body, object_class: OpenStruct).linkEventStats
  end

  private

  def get_token
    if Rails.cache.fetch('google_api_access_token')
      Rails.cache.fetch('google_api_access_token')
    else
      puts "Gerating new google api access token"
      auth = Google::Auth::ServiceAccountCredentials.make_creds(scope: url)
      token = auth.fetch_access_token!
      Rails.cache.write('google_api_access_token', token, expires_in: 59.minute)
      token
    end
  end

  def authorization_header
    token = get_token
    { "Authorization" => "Bearer #{token["access_token"]}" }
  end

  [:get].each do |verb|
    define_method(verb) do |path, headers = nil|
      response = connection.send(verb, path) do |req|
        req.options.timeout = @timeout if @timeout
        req.headers.merge! headers if headers
      end

      validate_response response
    end
  end

  def validate_response(response)
    if response.status == 401
      puts "Token expired, retrying with a new token"

      uri = response.env.url
      headers = authorization_header
      retry_response = get(uri.to_param, headers)
      return retry_response
    end
    fail RequestError.new("Got #{response.status} from #{response.env.url}") unless response.status >= 200 && response.status <= 299

    response
  end
end