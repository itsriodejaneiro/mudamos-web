class SignaturesController < ApplicationController
  def show
    # Mocked
    @signature = Struct.new(:valid).new(true)
  end
end
