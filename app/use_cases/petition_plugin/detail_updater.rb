module PetitionPlugin
  class DetailUpdater
    def perform(detail, attrs, version_attrs)
      detail.update_attributes attrs 

      current_version = detail.current_version
      if current_version.nil? || current_version.body != version_attrs[:body]
        detail.petition_detail_versions << PetitionPlugin::DetailVersion.new(version_attrs)
      end

      detail.save
    end
  end
end
