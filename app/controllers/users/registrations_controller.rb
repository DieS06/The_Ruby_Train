# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :prevent_status_change_by_self, only: [:update]
  
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    profile_path(resource.profile)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def prevent_status_change_by_self
    return if current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
    return unless resource.status_changed?

    resource.errors.add(:status, "Can't be changed manually.")
    render :edit, status: :unprocessable_entity
  end

  def admin_or_super_admin?
    roles.any? { |r| r.name.in?(%w[admin super_admin]) }
  end

  def sign_up_params
    allowed = base_permitted_user_params
    allowed << :status if current_user&.has_role?(:admin) || current_user&.has_role?(:super_admin)
    allowed << {role_ids: [] } if current_user&.has_role?(:admin) || current_user&.has_role?(:super_admin)
    params.require(:user).permit(*allowed)
  end

  def account_update_params
    allowed = base_permitted_user_params
    allowed << :current_password
    allowed << :status if current_user&.has_role?(:admin) || current_user&.has_role?(:super_admin)
    allowed << { role_ids: [] } if current_user&.has_role?(:admin) || current_user&.has_role?(:super_admin)
    params.require(:user).permit(*allowed)
  end

  def respond_with(resource, _opts = {})
    token = request.env['warden-jwt_auth.token']
    if resource.persisted?
      render json: {
        token: token,
        message: 'Signed up successfully.',
        user: UserSerializer.new(resource)
      }, status: :created
    else
      render json: {
        errors: resource.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def respond_to_on_destroy
    head :no_content
  end

  def base_permitted_user_params
    [
      :first_name,
      :last_name,
      :email,
      :phone_number,
      :password, 
      :password_confirmation, 
    ]
  end
end