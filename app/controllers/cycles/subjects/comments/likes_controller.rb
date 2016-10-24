
class Cycles::Subjects::Comments::LikesController < ApplicationController
  before_action :set_cycle, :set_subject, :set_comment
  respond_to :js

  def create
    like = Like.new(comment: @comment, user: current_user)
    respond_to do |format|
      if like.save
        format.json { head :no_content }
      else
        format.json { head :unprocessable_entity }
      end
    end
  end

  def destroy
    like = @comment.likes.where(user: current_user).limit(1).first
    like.unlike
    render json: {head: :no_content}
  end

  private

  def set_comment
    @comment = @subject.comments.find params[:comment_id]
  end
  def set_cycle
    @cycle = Cycle.find params[:cycle_id]
  end

  def set_subject
    @subject = @cycle.subjects.find params[:subject_id]
  end

  def resource_create_params
    params.require(:comment).permit(
        :content,
        :parent_id,
        :is_anonymous
    )
  end
end
