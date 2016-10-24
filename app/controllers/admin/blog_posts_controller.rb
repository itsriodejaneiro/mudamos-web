class Admin::BlogPostsController < Admin::ApplicationController
  before_action :set_plugin_relations, only: [:new, :edit, :create, :update]

  def index
    if @cycle
      @blog_posts = @cycle.blog_posts
    else
      @blog_posts = BlogPost.all
    end
  end

  def show
    @blog_post = BlogPost.find params[:id]
  end

  def new
    @blog_post = BlogPost.new
  end

  def edit
    @blog_post = BlogPost.find(params[:id])
  end

  def create
    @blog_post = BlogPost.new blog_post_params

    if @blog_post.save
      flash[:success] = "Post criado com sucesso."
      redirect_to [:admin, @blog_post]
    else
      flash[:error] = "Ocorreu algum erro ao criar o post."
      render :new
    end
  end

  def update
    @blog_post = BlogPost.find(params[:id])
    @blog_post.assign_attributes blog_post_params

    fast_updated = (@blog_post.highlighted_changed? or @blog_post.active_changed?)

    if @blog_post.save
      flash[:success] = "Post atualizado com sucesso."

      if fast_updated
        redirect_to request.referrer
      else
        redirect_to [:admin, @blog_post]
      end
    else
      flash[:error] = "Ocorreu algum erro ao atualizar o post."
      render :edit
    end
  end

  def destroy
    @blog_post = BlogPost.find(params[:id])

    if @blog_post.destroy
      flash[:success] = "Post apagado com sucesso."
    else
      flash[:error] = "Ocorreu algum erro ao apagar o post."
    end
    redirect_to [:admin, :blog_posts]
  end

  private

    def set_plugin_relations
      @plugin_relations_cycles = PluginRelation.blog.map{|x| [x.cycle.name,x.id]}
    end

    def blog_post_params
      params.require(:blog_post).permit(
        :active,
        :highlighted,
        :title,
        :content,
        :plugin_relation_id,
        :picture,
        :release_date
      )
    end
end
