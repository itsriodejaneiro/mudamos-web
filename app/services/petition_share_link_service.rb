class PetitionShareLinkService
  def initialize(
    api_key: Rails.application.secrets.firebase['api_key'],
    timeout: Rails.application.secrets.apis['mobile']['timeout'],
    url: "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=#{api_key}",
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

  def generate(phase)
    response = post(url, {
      dynamicLinkInfo: {
        dynamicLinkDomain: Rails.application.secrets.firebase["dynamic_link_domain"],
        link: generate_plip_url(phase),
        androidInfo: {
          androidPackageName: Rails.application.secrets.firebase["android_package"]
        },
        iosInfo: {
          iosBundleId: Rails.application.secrets.firebase["ios_package"]
        }
      },
      suffix: {
        option: "SHORT"
      },
    })

    JSON.parse(response.body)["shortLink"]
  end

  private

  def generate_plip_url(phase)
    Rails.application.routes.url_helpers.cycle_plugin_relation_url(
      phase.cycle,
      phase.plugin_relation
    )
  end

  [:post].each do |verb|
    define_method(verb) do |path, body, headers = nil|
      body = connection.send(verb) do |req|
        req.url path
        req.body = JSON.generate(body) if body
        req.options.timeout = timeout if timeout

        req.headers["Content-Type"] = "application/json"
        req.headers.merge! headers if headers
      end

      body
    end
  end
end