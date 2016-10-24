class Api::V1::SubjectsController < Api::V1::ApplicationController

  def index
    self.collection = query_searched_collection
    self.collection = related_included_collection
    self.collection = paginated_collection

    status = 200

    if self.collection.empty?
      status = 204
    end

    render status: status, json: {
      model_instance_variable_plural => json_collection,
      # subjects_users: collection.map do |s|
      #   SubjectUser.where(user: current_user, subject: s)
      # end,
      page_size: @page_size,
      page: @page,
      total_pages: @total_pages
    }
  end

end
