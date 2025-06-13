class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :update]
  load_and_authorize_resource

  def show
    return render json: { error: "No profile found" }, status: :not_found if @profile.nil?
    render json: @profile, serializer: ProfileSerializer, status: :ok
  end

  def update
     if @profile.update(profile_params)
      render json: @profile, serializer: ProfileSerializer, status: :ok
    else
      render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:bio, :linkedin_url, :github_url, :website_url, :location, :company_name, :job_title)
  end

  def set_profile
    @profile = current_user.profile
  end
end
