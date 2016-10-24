class Cycles::VocabulariesController < ApplicationController
  before_action :set_cycle

  def index
    @vocabularies = @cycle.vocabularies
  end

  private

    def set_cycle
      @cycle = Cycle.find params[:cycle_id]
    end

end
