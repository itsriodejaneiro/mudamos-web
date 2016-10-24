class CreditsController < ApplicationController
	def index
    @categories = CreditCategory.includes(:credits).all
	end
end
