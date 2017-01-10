module PetitionPlugin
  class DetailUpdater
    def perform(detail, attrs, detail_body)
      detail.update_attributes attrs 

      current_version = detail.current_version
      if current_version.nil? || current_version.body != detail_body
        detail.petition_detail_versions << PetitionPlugin::DetailVersion.new(body: detail_body)
      end

      detail.save
    end
  end
end
