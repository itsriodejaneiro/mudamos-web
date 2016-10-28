class Admin::Cycles::PluginRelations::PetitionsController < Admin::ApplicationController

  attr_writer :petition_repository

  def petition_repository
    @petition_repository ||= PetitionRepository.new
  end

  def index
    @petition = petition_repository.mock
  end
end
