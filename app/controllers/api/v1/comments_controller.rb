class Api::V1::CommentsController < Api::V1::ApplicationController
  before_action :set_subject

  def index
      if params[:comment_id].present?
        self.collection = @subject.comments.find(params[:comment_id]).children
      else
        self.collection = @subject.comments.roots
      end

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
        subject_user: SubjectUser.where(user: current_user, subject: @subject).limit(1).first,
        page_size: @page_size,
        page: @page,
        total_pages: @total_pages
      }
  end

  def show
    self.resource = @subject.comments.find params[:id]
    super
  end

  def create
    self.resource.user = current_user
    self.resource.subject = @subject

    if params[:comment_id]
      self.resource.parent = @subject.comments.find params[:comment_id]
    end

    super
  end

  def update
    if user_signed_in? and self.resource.user == current_user
      self.resource = @subject.comments.find params[:id]
      super
    else
      render_unauthorized
    end
  end

  private

    def set_subject
      @subject = Subject.find params[:subject_id]
    end

end
