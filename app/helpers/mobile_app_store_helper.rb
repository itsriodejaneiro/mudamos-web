module MobileAppStoreHelper
  def android_store_page
    Rails.application.secrets.mobile_app["store_page"]["android"] 
  end

  def apple_store_page
    Rails.application.secrets.mobile_app["store_page"]["ios"] 
  end
end
