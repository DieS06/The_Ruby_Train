# frozen_string_literal: true

# == Users::ConfirmationsController
#
# @!group Controllers / Auth
#
# Confirmmation of account via e-mail (Devise :confirmable).
#
# === Endpoints
# * **POST /users/confirmation** → `#create`  (resend mail)
# * **GET  /users/confirmation** → `#show`    (token in URL)
#
# @!endgroup
#

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  def create
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      redirect_to profiles_path, notice: I18n.t("devise.confirmations.confirmed")
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  protected
  def after_confirmation_path_for(resource_name, resource)
    "/profiles"
  end
end
