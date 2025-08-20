# frozen_string_literal: true

# == ApplicationController
#
# @!group Controllers / Base
#
# Controlador raíz. Maneja:
# * Global authentication (`authenticate_user!`)
# * Global authorization (CanCanCan `check_authorization`)
# * JSON errors handling (`AccessDenied`, `MissingWarden`)
#
# @!endgroup
#

class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  include CanCan::ControllerAdditions

  protect_from_forgery with: :exception
  before_action :authenticate_user!, unless: :devise_controller?
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { error: "Access Denied" }, status: :forbidden }
      format.html { redirect_to root_path, alert: "Not authorized" }
    end
  end
end
