class FaqsController < ApplicationController
  layout "static"

  def index
    @faqs = Faq.published
    @title = "Mudamos | Dúvidas"
    @image = asset_url("faq-image.png")
    @description= "Acesse os principais dados e outras informações sobre o aplicativo Mudamos."
  end

  private

  def asset_url(path)
    host_url = request.path == "/" ? request.url : request.original_url.split(request.path).first
    asset_path = ActionController::Base.helpers.asset_url(path)
    host_url.chomp("/") + asset_path
  end
end
