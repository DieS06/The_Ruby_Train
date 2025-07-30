# frozen_string_literal: true

# == Users::RegistrationsController
#
# @!group Controllers / Auth
#
# Registration, update and states administration of {User}.
#
# === Endpoints
# * **POST /users** → `#create`
# * **PUT /users**  → `#update`
# * **PUT /users/:id/state** → `#update_state` (only admin / super_admin)
# * **DELETE /users/:id** → `#destroy` (suspends user)
#
# @example JSON Body (Plain JSON)
#   POST /users
#   {
#     "user": {
#       "email": "user@example.com",
#       "password": "Password123!",
#       "first_name": "New",
#       "last_name": "User",
#       "country": "Costa Rica",
#       "phone_number": "+506000000"
#     }
#   }
#
# @!endgroup
#

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :authenticate_user!, only: [ :create, :update_state ]
  before_action :prevent_status_change_by_self, only: [ :update ]

  # POST /resource
  def create
    begin
      build_resource(permitted_user_params)
      resource.state ||= :pending

      unless resource.save
        raise ActiveRecord::Rollback
      end

      resource.add_role(:student)
      resource.build_profile!

      render json: {
          message: "Registration successful. Please check your email to confirm your account before signing in"
        }, status: :created
    rescue => e
        render json: { errors: resource.errors.full_messages.presence }, status: :unprocessable_entity
    end
  end

  # PUT /resource
  def update
    authorize! :update, current_user
    if current_user.update(permitted_user_params)
      render json: current_user, serializer: UserSerializer
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /users/:id/state
  def update_state
    user = User.find(params[:id])
    authorize! :update_state, user

    unless current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    unless User.states.key?(params[:state])
      return render json: { error: "Invalid state" }, status: :unprocessable_entity
    end

    if user.update(state: params[:state])
      render json: { message: "User state updated to #{user.state}." }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    user = User.find(params[:id])
    authorize! :destroy, user

    return render json: { error: "Super Admin can't be deleted!" }, status: :forbidden if user.has_role?(:super_admin)
    return render json: { message: "Already suspended." }, status: :ok if user.suspended_state?

    user.suspended_state!
    render json: { message: "User has been suspended." }, status: :ok
  end

  private

  def prevent_status_change_by_self
    return if current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
    return unless current_user.state_changed?

    current_user.errors.add(:state, "Can't be changed manually.")
    render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
  end

  def permitted_user_params
    allowed = [
      :first_name,
      :last_name,
      :country,
      :phone_number,
      :email,
      :password,
      :password_confirmation,
      profile_attributes: [
        :bio, :linkedin_url, :github_url, :website_url,
        :location, :company_name, :job_title
      ]
    ]
    allowed << :state if current_user&.has_role?(:admin) || current_user&.has_role?(:super_admin)
    allowed << { role_ids: [] } if current_user&.has_role?(:admin) || current_user&.has_role?(:super_admin)
    params[:user] ? params.require(:user).permit(*allowed) : params.permit(*allowed)
  end
end
