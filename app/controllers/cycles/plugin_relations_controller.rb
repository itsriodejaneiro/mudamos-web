class Cycles::PluginRelationsController < ApplicationController

  def show
    @cycle = Cycle.find params[:cycle_id]
    @plugin_relation = @cycle.plugin_relations.find params[:id]

    case @plugin_relation.plugin.plugin_type
    when 'Discussão'
      # redirect_to [:admin, @cycle, @plugin_relation, :subjects]
    when 'Relatoria'
      respond_to do |format|
        format.html {
          set_charts_variables
          render 'compilation'
        }
        format.csv {
          send_csv @cycle.comments.to_public_csv, "comentarios-#{@cycle.slug}"
        }
      end
    when 'Biblioteca'
      # redirect_to [:admin, @cycle, @plugin_relation, :materials]
    when 'Glossário'
      # redirect_to [:admin, @cycle, @plugin_relation, :vocabularies]
    when 'Blog'
      # redirect_to [:admin, @cycle, :blog_posts]
    end
  end

  private

    def set_charts_variables
      range_start = @cycle.initial_date
      range_end = @cycle.final_date

      # ChartableCache.clear_cache @cycle
      ChartableCache.set_cache range_start, range_end, @cycle

      @user_profile_count_in_range = Rails.cache.fetch("#{@cycle.slug}_user_profile_count_in_range")
      @user_gender_count_in_range = Rails.cache.fetch("#{@cycle.slug}_user_gender_count_in_range")
      @user_age_count_in_range = Rails.cache.fetch("#{@cycle.slug}_user_age_count_in_range")
      @user_state_count_in_range = Rails.cache.fetch("#{@cycle.slug}_user_state_count_in_range")
      @subjects_comments_region_count_in_range = Rails.cache.fetch("#{@cycle.slug}_subjects_comments_region_count_in_range")
      @subjects_users_region_count_in_range = Rails.cache.fetch("#{@cycle.slug}_subjects_users_region_count_in_range")
      @subjects_users_profile_count_in_range = Rails.cache.fetch("#{@cycle.slug}_subjects_users_profile_count_in_range")
      @user_profile_anonymous_count_in_range = Rails.cache.fetch("#{@cycle.slug}_user_profile_anonymous_count_in_range")
      @subjects_users_profile_anonymous_count_in_range = Rails.cache.fetch("#{@cycle.slug}_subjects_users_profile_anonymous_count_in_range")
    end

end
