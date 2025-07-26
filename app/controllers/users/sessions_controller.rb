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
  include RackSessionFix
  respond_to :json

  skip_before_action :verify_authenticity_token, only: :create

  def create
    self.resource = warden.authenticate!(auth_options)
    token = request.env["warden-jwt_auth.token"]

    cookies[:access_token] = {
      value: token,
      httponly: true,
      same_site: :lax,
      path: "/",
      secure: Rails.env.production?,
      expires: 180.minutes.from_now
    }

    render json: { message: "Logged in", user: resource.slice(:id, :email) }, status: :ok
  end
end
