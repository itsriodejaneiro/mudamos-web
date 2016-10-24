class Api::V1::Cycles::Subjects::Comments::LikesController < Api::V1::ApplicationController
  before_action :set_subject, :set_comment

  def create
    if user_signed_in?
      self.resource = Like.new(comment: @comment, user: current_user)
      super
    else
      render_401
    end
  end

  def destroy
    if user_signed_in?
      self.resource = Like.where(comment: @comment, user: current_user).limit(1).first

      if self.resource
        self.resource.destroy
        render status: 204, nothing: true
      else
        render_404
      end
    else
      render_401
    end
  end

  private

    def set_comment
      @comment = @subject.comments.find params[:comment_id]
    end

    # def set_cycle
    #   @cycle = Cycle.find params[:cycle_id]
    # end

    def set_subject
      @subject = Subject.find params[:subject_id]
    end
end
