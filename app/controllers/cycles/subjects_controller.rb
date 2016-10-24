class Cycles::SubjectsController < ApplicationController
  before_action :set_cycle

  def index
    @subjects = @cycle.subjects.random_order
  end

  def show
    @subject = @cycle.subjects.find params[:id]

    @basic_share_params = params.reject { |k, v| ["controller", "action", "cycle_id", "id", "comment_id", "subject_id", "comments"].include? k }

    if params["comments"].present?
      @selected_comment_id = params["comments"].split(',').last.split("-").last
    end

    unless params['comment-filter'].blank?
      @comments = @subject.comments.roots.with_includes.send(params['comment-filter'].to_sym)
    else
      @comments = Comment.hot(@subject.comments.roots.with_includes)
    end

    unless Rails.env.production?
      @comments = @comments.first(10)
    end

    respond_to do |format|
      format.html
      format.json {
        render json: {
          html: render_to_string(file: 'layouts/shared/vocabulary_modal.html', layout: false)
        }
      }
    end
  end

  private

    def set_cycle
      @cycle = Cycle.find params[:cycle_id]
    end
end
