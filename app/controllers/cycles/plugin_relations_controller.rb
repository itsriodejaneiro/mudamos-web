class Cycles::PluginRelationsController < ApplicationController

  attr_writer :presignature_repository

  def presignature_repository
    @presignature_repository ||= PetitionPlugin::PresignatureRepository.new
  end

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
    when 'Petição'
      set_petition_info
      render 'petition'
    when 'Biblioteca'
      # redirect_to [:admin, @cycle, @plugin_relation, :materials]
    when 'Glossário'
      # redirect_to [:admin, @cycle, @plugin_relation, :vocabularies]
    when 'Blog'
      # redirect_to [:admin, @cycle, :blog_posts]
    end
  end

  helper_method :past_versions
  def past_versions
    PetitionPlugin::DetailRepository.new.past_versions_desc(@petition)
  end

  private

    def set_charts_variables
      range_start = @cycle.initial_date
      range_end = @cycle.final_date

      if params[:clear_cache] == true or params[:clear_cache] == 'true'
        ChartableCache.clear_cache @cycle
      end
      
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

    def set_petition_info
      petition
      phase
      user_signed_petition
    end

    def petition
      @petition ||= phase.plugin_relation.petition_detail
    end

    def phase
      @phase ||= @plugin_relation.related
    end

    def user_signed_petition
      if @user_signed_petition.nil? && current_user
        @user_signed_petition = presignature_repository.user_signed_petition?(current_user.id, @plugin_relation.id)
      end

      @user_signed_petition
    end
end
