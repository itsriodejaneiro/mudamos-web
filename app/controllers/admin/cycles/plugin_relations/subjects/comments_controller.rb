class Admin::Cycles::PluginRelations::Subjects::CommentsController < Admin::ApplicationController
  before_action :set_subject
  before_action :set_parent_comment, if: -> { params[:comment_id].present? }

  def index
    if params[:comment_id].present?
      @comment = @subject.comments.find params[:comment_id]
      @comments = @comment.children
    else
      @comments = @subject.comments.roots
    end

  end

  def show
    @comment = @subject.comments.find params[:id]

    params[:order] ||= 'created_at'
    @comments = @comment.children.order("#{params[:order]} DESC").page(params[:page]).per(qty)

    @comment_profile_count_in_range = @comments.includes(:user, user: :profile).reject { |x| x.user.profile.blank? }.group_by { |x| x.user.profile.name }
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = @parent_comment.children.new comment_params
    @comment.user = User.unscoped.where(is_admin: true).first
    @comment.subject = @subject

    if @comment.save
      flash[:success] = "Resposta criada com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, @subject, @parent_comment]
    else
      flash[:error] = "Ocorreu algum erro ao criar o comentário."
      render :new
    end
  end

  private

    def comment_params
      params.require(:comment).permit(
        :content
      )
    end

    def set_subject
      @subject = @plugin_relation.subjects.find(params[:subject_id])
    end

    def set_parent_comment
      @parent_comment = @subject.comments.find params[:comment_id]
    end

end
