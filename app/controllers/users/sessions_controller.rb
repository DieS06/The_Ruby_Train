# frozen_string_literal: true

# == Users::SessionsController
#
# @!group Controllers / Auth
#
# Login / logout with JWT.
#
# === Endpoints
# * **POST /users/sign_in**   → `#create`
# * **DELETE /users/sign_out** → `#destroy`
#
# @example Sign-in (JSON)
#   POST /users/sign_in
#   { "user": { "email": "me@site.com", "password": "Secret123!" } }
#
# @!endgroup
#

class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  private

  def respond_with(resource, _opts = {})
    token = request.env["warden-jwt_auth.token"]

    if token.present?
      render json: {
        token: token,
        user: UserSerializer.new(resource).as_json
      }, status: :ok
    else
      render json: { error: "Authentication failed" }, status: :unauthorized
    end
  end
end
