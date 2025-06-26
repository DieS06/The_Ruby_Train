# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!, only: [:create]
  respond_to :json
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :prevent_status_change_by_self, only: [:update]
  
  
  # POST /resource
  def create
    begin
      build_resource(permitted_user_params)
      resource.state ||= "pending"
      
      unless resource.save
        raise ActiveRecord::Rollback
      end

      resource.add_role(:student)
      resource.build_profile!

      render json: {
          message: "Registration successful. Please check your email to confirm your account before signing in"
        }, status: :created 
    rescue => e
        render json: { errors: resource.errors.full_messages.presence || [e.message] }, status: :unprocessable_entity
    end
  end

  # PUT /resource
  def update
    if current_user.update(permitted_user_params)
      render json: current_user, serializer: UserSerializer
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_state
    user = User.find(params[:id])

    unless current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    unless States::UserState.all.include?(params[:state])
      return render json: { error: "Invalid state" }, status: :unprocessable_entity
    end

    if user.update(state: params[:state])
      render json: { message: "User state updated to #{user.state}." }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])

    if user.has_role?(:super_admin)
      return render json: { error: "Super Admin can't be deleted!" }, status: :forbidden
    end

    if user.suspended_state?
      return render json: { message: "This #{user} is already suspended." }, status: :ok
    end

    if user.update(state: States::UserStates::SUSPENDED)
      render json: { message: "User has been suspended." }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def prevent_status_change_by_self
    return if current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
    return unless resource.state_changed?

    resource.errors.add(:status, "Can't be changed manually.")
    render :edit, status: :unprocessable_entity
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
    params.require(:user).permit(*allowed)
  end
end