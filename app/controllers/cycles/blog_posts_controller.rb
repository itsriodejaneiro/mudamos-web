class Cycles::BlogPostsController < ApplicationController
  before_action :set_cycle
  before_action :set_highlights

  def index
    @blog_posts = @cycle.blog_posts.released.page params[:page]
    @big_blog_post = @blog_posts.highlights.sample
    render 'blog_posts/index'
  end

  def show
    @blog_post = @cycle.blog_posts.find params[:id]
    render 'blog_posts/show'
  end

  private

    def set_cycle
      @cycle = Cycle.find params[:cycle_id]
    end

    def set_highlights
      @posts_highlights = @cycle.blog_posts.highlights
    end
end
