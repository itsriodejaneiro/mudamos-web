module Api
  module UrlHelpers
    def normalize_url(url)
      return url if url.blank?

      parsed_url = URI.parse(url)
      parsed_url.scheme ||= "http"

      parsed_url.to_s
    end
  end
end
