class FaqsController < ApplicationController
  layout "static"

  def index
    @faqs = Faq.published
    @title = "Mudamos | Dúvidas"
    @image = asset_url("faq-image.png")
    @description= "Acesse os principais dados e outras informações sobre o aplicativo Mudamos."
  end
end
