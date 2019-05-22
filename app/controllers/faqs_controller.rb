class FaqsController < ApplicationController
  layout "static"
  
  def index
    @faqs = Faq.published
  end
end
