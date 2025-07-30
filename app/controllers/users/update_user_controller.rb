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
# === Params
# * `first_name`, `last_name`, `email`, `phone_number`, `country`
#
class Users::UpdateUserController < ApplicationController
  before_action :authenticate_user!
  # skip_before_action :verify_authenticity_token

  def update
    if current_user.update(user_params)
      return head :no_content if user_params.to_h.all? { |k, v| v == current_user[k] }
      render json: { message: "Information updated successfully", user: current_user }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    allowed = %i[first_name last_name phone_number country]
    allowed << :email if can_changed_email?
    params.require(:user).permit(allowed)
  end

  def can_changed_email?
    false
  end
end
