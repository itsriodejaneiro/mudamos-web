module PetitionPlugin
  class AccountRemover
    Result = Struct.new(:success)

    attr_accessor :service

    def initialize(service: MobileApiService.new)
      @service = service
    end

    def perform(email:)
      service.remove_account email: email
      Result.new(true)
    rescue MobileApiService::ValidationError
      Result.new
    end
  end
end
