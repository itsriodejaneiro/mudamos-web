module PetitionPlugin

  class DetailUpdater
    Response = Struct.new(:success, :detail, :version)

    def perform(detail, attrs, detail_body)
      response = Response.new

      attrs = if detail.new_record?
                create_attrs(attrs)
              else
                update_attrs(attrs)
              end

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

    def create_attrs(attrs)
      attrs = attrs.slice(
        :call_to_action,
        :initial_signatures_goal,
        :signatures_required,
        :requires_mobile_validation,
        :presentation,
        :video_id,
        :scope_coverage,
        :city_id,
        :uf,
      )

      attrs[:uf] = attrs[:uf].presence
      attrs
    end

    def update_attrs(attrs)
      create_attrs(attrs).except(
        :scope_coverage,
        :city_id,
        :uf,
      )
    end
  end
end
