module PetitionPlugin

  Response = Struct.new(:android, :ios, :other)

  class DynamicLinkMetrics
    attr_accessor :share_link_metrics_service

    def initialize(share_link_metrics_service: ShareLinkMetricsService.new)
      @share_link_metrics_service = share_link_metrics_service
    end

    def perform(petition)
      response = Response.new

      @metrics = share_link_metrics_service.get_metrics petition.share_link, 30

      response.android = android
      response.ios = ios
      response.other = other

      response
    end

    private

    def metrics
      @metrics || []
    end

    def android
      android_metrics = metrics.select { |metric| metric.platform == "ANDROID"}
      add_defaults_to_dynamic_link_metrics android_metrics, "ANDROID"
    end

    def ios
      ios_metrics = metrics.select { |metric| metric.platform == "IOS"}
      add_defaults_to_dynamic_link_metrics ios_metrics, "IOS"
    end

    def other
      other_metrics = metrics.select { |metric| metric.platform == "OTHER"}
      add_defaults_to_dynamic_link_metrics other_metrics, "OTHER"
    end

    def add_defaults_to_dynamic_link_metrics(metrics, platform)
      metrics_with_defaults = []
      metrics_with_defaults << get_metric_with_default(metrics, "CLICK", platform)
      metrics_with_defaults << get_metric_with_default(metrics, "REDIRECT", platform)
      metrics_with_defaults << get_metric_with_default(metrics, "APP_INSTALL", platform)
      metrics_with_defaults << get_metric_with_default(metrics, "APP_FIRST_OPEN", platform)
      metrics_with_defaults << get_metric_with_default(metrics, "APP_RE_OPEN", platform)

      metrics_with_defaults
    end

    def get_metric_with_default(metrics, event, platform)
      metric = metrics.find { |metric| metric.event == event }
      metric ? metric : OpenStruct.new(count: 0, event: event, platform: platform)
    end
  end
end
