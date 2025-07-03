# frozen_string_literal: true

# == Users::PasswordsController
#
# @!group Controllers / Auth
#
# Password reset (sends e-mail with token).
#
# === Endpoints
# * **POST /users/password** → `#create`
#
# @!endgroup
#

class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  skip_before_action :authenticate_user!, only: [ :create, :new ]
  skip_authorization_check

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if resource.errors.empty?
      render json: { message: "Password reset instructions sent. Please check your email." }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
