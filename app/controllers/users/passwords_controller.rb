# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: [:create, :new]
  skip_authorization_check

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if resource.errors.empty?
      render json: { message: 'Password reset instructions sent. Please check your email.' }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # private

  # def respond_with(resource, _opts = {})
  #     if successfully_sent?(resource)
  #       render json: { message: 'Password reset instructions sent. Please check your email.' }, status: :ok
  #     else
  #       errors_to_return = if resource.respond_to?(:errors) && !resource.errors.empty?
  #                           resource.errors.full_messages
  #                         elsif resource.is_a?(Hash) && resource.key?(:errors) # CORREGIDO
  #                           resource[:errors]
  #                         else
  #                           ['Failed to send password reset instructions. Please check your email and try again.']
  #                         end
  #       render json: { errors: errors_to_return }, status: :unprocessable_entity
  #     end
  # end
end
