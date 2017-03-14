module PetitionPlugin

  Response = Struct.new(:success, :detail, :version)

  class DetailUpdater
    def perform(detail, attrs, detail_body)
      response = Response.new

      detail.update_attributes attrs

      current_version = detail.current_version
      if current_version.nil? || current_version.body != detail_body
        response.version = PetitionPlugin::DetailVersion.new(body: detail_body)
        detail.petition_detail_versions << response.version
      end

      response.success = detail.save
      response.detail = detail

      response
    end
  end
end
