class ProfilesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: [ :me ]

  def show
    render json: @profile, serializer: ProfileSerializer, status: :ok
  end

  def me
    profile = current_user.profile
    authorize! :read, profile
    render json: profile, serializer: ProfileSerializer, status: :ok
  end

  def update_me
    profile = current_user.profile
     authorize! :update, profile
    if profile.update(profile_params)
      render json: profile, serializer: ProfileSerializer, status: :ok
    else
      render json: { errors: profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(
      :bio,
      :linkedin_url,
      :github_url,
      :website_url,
      :location,
      :company_name,
      :job_title
    )
  end
end
