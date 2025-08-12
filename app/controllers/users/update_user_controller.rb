# frozen_string_literal: true

# == UpdateInfoController
#
# @!group 02-Controllers / Users
#
# Updates basic user data via JSON API. Requires JWT authentication.
#
# === Endpoint
# * PUT /users/update_info
#
# Updates basic fields of the current user via JSON.
#
# === Params (JSON)
# * user[first_name] : String
# * user[last_name]  : String
# * user[phone_number] : String
# * user[country]    : String
# * (email)          : String (disabled unless +can_changed_email?+ returns true)
#
# === Responses
# * 200 OK: { message, user: { first_name, last_name, email, phone_number, country, updated_at } }
# * 200 OK (no changes): { message: "No changes", user: {...} }
# * 422 Unprocessable Entity: { errors: [ ... ] }
#

class Users::UpdateUserController < ApplicationController
  skip_authorization_check
  before_action :authenticate_user!
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  def update
    authorize! :update, current_user

    user = current_user
    user.assign_attributes(user_params)

    unless user.changed?
      render json: {
        message: "No changes detected",
        user: user.slice(:first_name, :last_name,
        :email, :phone_number, :country, :updated_at)
      }, status: :ok
      return
    end

    if user.save
      render json: {
        message: "Information updated successfully",
        user: user.slice(:first_name, :last_name,
        :email, :phone_number, :country, :updated_at)
      }, status: :ok
    else
      render json: { errors: user.errors.full_messages },
      status: :unprocessable_entity
    end
  end

  private

  def user_params
    allowed = %i[first_name last_name phone_number country]
    allowed << :email if can_changed_email?
    params.require(:user).permit(*allowed)
  end

  def can_changed_email?
    false
  end
end
