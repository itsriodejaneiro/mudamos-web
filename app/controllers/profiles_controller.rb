class ProfilesController < ApplicationController
  respond_to :js

  def index
    if params[:profile_id].present?
      @profiles = Profile.where(parent_id: params[:profile_id]).to_a

      other = Profile.where(parent_id: params[:profile_id], name: 'Outros').first

      if other
        other_index = @profiles.find_index(other)
        @profiles.delete_at other_index

        @profiles.push other
      end

      render json: {
        description: Profile.find(params[:profile_id]).description,
        profiles: @profiles.map { |x| [x.name, x.id, x.description] }
      }
    else
      render json: {
        profiles: []
      }
    end
  end
end
