class ShareLinkMetricsService

  class RequestError < StandardError; end
  class InvalidToken < StandardError; end

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
    response = get("https://firebasedynamiclinks.googleapis.com/v1/#{share_link_addressable}/linkStats?durationDays=7")
    if response
      JSON.parse(response.body, object_class: OpenStruct).linkEventStats
    end
  end

  private

  def get_token(force: false)
    Rails.cache.fetch('google_api_access_token', force: force, expires_in: 59.minutes) do
      puts "Gerating new google api access token"
      auth = Google::Auth::ServiceAccountCredentials.make_creds(scope: url)
      auth.fetch_access_token!
    end
  end

  def authorization_header(force: false)
    token = get_token(force: force)
    { "Authorization" => "Bearer #{token["access_token"]}" }
  end

  [:get].each do |verb|
    define_method(verb) do |path, headers = {}, authorization = true|
      begin
        retries ||= 0
        headers.merge! authorization_header if authorization
        response = connection.send(verb, path) do |req|
          req.options.timeout = @timeout if @timeout
          req.headers.merge! headers if headers
        end

        validate_response response
      rescue InvalidToken
        retry if (retries += 1 ) < 3
      end
    end
  end

  def validate_response(response)
    if response.status == 401
      get_token(force: true)
      fail InvalidToken.new("Invalid Token, a new token was generate")
    end
    fail RequestError.new("Got #{response.status} from #{response.env.url}") unless response.status >= 200 && response.status <= 299

    response
  end
end