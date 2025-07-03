class ProfilesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: [ :me ]

  def index
    render "profiles/index", formats: [ :html ], layout: "application"
  end

  def me
    profile = current_user.profile
    authorize! :read, profile
    render json: profile, serializer: ProfileSerializer, status: :ok
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
