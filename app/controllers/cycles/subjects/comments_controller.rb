class Cycles::Subjects::CommentsController < ApplicationController
  before_action :set_cycle, :set_subject

  def index
    # @page_size = (params[:page_size] || 10).to_i
    # @page = (params[:page] || 0).to_i

    # offset = (@page * @page_size)

    if params[:comment_id].present?
      @comments = @subject.comments.find(params[:comment_id]).children.with_includes
      # @total_pages = (@comments.length / @page_size).ceil
      # @comments = @comments.offset(offset).limit(@page_size)
    else
      @comments = Comment.hot(@subject.comments.roots.with_includes)
      # @total_pages = (@comments.length / @page_size).ceil
      # @comments = @comments[offset..(offset + @page_size)]
    end

    render json: {
      comments_html: @comments.map do |c|
        render_to_string(file: 'widgets/_comment', layout: false, locals: { comment: c, color: @cycle.color })
      end.join('')
    }
  end

  def create
    @comment = @subject.comments.new resource_create_params
    @comment.user = current_user

    if @comment.save
      if @comment.is_anonymous
        flash[:success] = "Comentário enviado com sucesso no modo anônimo."
      else
        flash[:success] = "Comentário enviado com sucesso."
      end
      redirect_to "#{cycle_subject_path(@cycle, @subject)}#comment-#{@comment.root.id}"
    else
      flash[:error] = "Não foi possível criar seu comentário."
      redirect_to [@cycle, @subject]
    end
  end

  private

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
