class Admin::GridHighlightsController < Admin::ApplicationController
  def index
    @highlights = GridHighlight.order('id ASC').all

    @social_links = SocialLink.pluck(:name, :id)
    @blog_posts = BlogPost.released.pluck(:title, :id)
    @cycles = Cycle.pluck(:name, :id)
  end

  def update
    @grid_highlight = GridHighlight.find params[:id]

    @grid_highlight.target_object = nil
    @grid_highlight.blog = nil
    @grid_highlight.vocabulary = nil

    if grid_highlight_params[:target_object_type] == 'blog'
      @grid_highlight.blog = true
    elsif grid_highlight_params[:target_object_type] == 'vocabulary'
      @grid_highlight.vocabulary = true
      @grid_highlight.target_object = Cycle.last
    else
      @grid_highlight.assign_attributes(grid_highlight_params)
    end

    if @grid_highlight.save
      flash[:success] = "Destaque salvo com sucesso."
    else
      flash[:error] = "Erro ao salvar destaque"
    end 

    redirect_to [:admin, :grid_highlights]
  end

  private

    def grid_highlight_params
      params.require(:grid_highlight).permit(
        :target_object_id,
        :target_object_type
      )
    end
end
