module MobileAppHelper
  def allowed_to_show_smart_banner?
    # Safari has it's own smart banner
    #
    # For more information check https://developer.apple.com/library/content/documentation/AppleApplications/Reference/SafariWebContent/PromotingAppswithAppBanners/PromotingAppswithAppBanners.html
    return false if browser.platform.ios? && browser.safari?

    cookie = cookies[:smart_banner_dismiss]
    (browser.device.mobile? || browser.device.tablet?) && (cookie.nil? || (Time.now >= Time.at(cookie) + 15.days))
  end

  def android_store_page
    Rails.application.secrets.mobile_app["store_page"]["android"] 
  end

  def apple_store_page
    Rails.application.secrets.mobile_app["store_page"]["ios"] 
  end
end
