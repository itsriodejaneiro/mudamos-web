module Api::V2::Responses
  class Base
    attr_reader :data
    attr_writer :translator

    def initialize(data:)
      @data = data
    end

    def self.status(status)
      class_eval do
        define_method(:status) { status }
      end
    end

    # @return [#translate]
    def translator
      @translator ||= I18n
    end

    def status
      raise NotImplementedError
    end

    def as_json
      { status: status, data: data }
    end

    def to_json(_options = nil)
      as_json.to_json
    end
  end

  class SuccessResponse < Base
    status :success
  end

  # Base class for fail or error responses
  class BadReponse < Base
    def type
      self.class.name.split("::").last.underscore
    end

    def as_json
      json = super
      json[:data] ||= {}
      json[:data].merge! type: type
      json
    end
  end

  # Fail responses are used when there was a problem with the data
  # submitted, or some pre-condition of the API call wasn't satisfied
  class FailReponse < BadReponse
    status :fail

    def initialize(message: nil, **kwargs)
      super(**kwargs)

      @message = message
    end

    def message
      case @message
      when Symbol
        translator.translate msg, scope: [:api, :v2, :errors]
      when String
        msg
      else
        translator.translate type, scope: [:api, :v2, :errors]
      end
    end

    def as_json
      json = super
      json[:data] ||= {}
      json[:data].merge! message: message
      json
    end
  end

  # An error occurred in processing the request, i.e. an exception was thrown
  class ErrorResponse < BadReponse
    status :error

    def initialize(message: nil, data: nil, **kwargs)
      super(**kwargs.merge(data: data))

      @message = message
    end

    def self.code(code)
      class_eval do
        define_method(:code) { code }
      end
    end

    def code
      raise NotImplementedError
    end

    def message
      case @message
      when Symbol
        translator.translate msg, scope: [:api, :v2, :errors]
      when String
        msg
      else
        translator.translate type, scope: [:api, :v2, :errors]
      end
    end

    def as_json
      super.merge message: message, code: code
    end
  end

  class InternalError < ErrorResponse
    include Swagger::Blocks

    code 500

    swagger_schema :'Api::V2::Responses::InternalError' do
      extend Api::V2::SwaggerResponses::BaseResponse

      property :message do
        key :type, :string
      end

      property :code do
        key :type, :integer
        key :default, 500
      end
    end
  end
end
