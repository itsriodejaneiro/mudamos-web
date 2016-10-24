class BlogPostsController < ApplicationController
  before_action :set_highlights

  def index
    @blog_posts = BlogPost.released.page params[:page]
    @big_blog_post = BlogPost.highlights.sample
  end

  def show
    @blog_post = BlogPost.find params[:id]
  end

  private

    def set_highlights
      @posts_highlights = BlogPost.highlights
    end
end
