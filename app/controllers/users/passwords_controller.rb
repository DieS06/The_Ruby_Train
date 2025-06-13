# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

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

  private

  def respond_with(resource, _opts = {})
    if successfully_sent?(resource)
      render json: { message: 'Password reset instructions sent.' }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
