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

  protect_from_forgery with: :null_session, unless: -> { request.format.html? }
  before_action :authenticate_user!, unless: :devise_controller?
  # before_action :set_locale
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { error: "Access Denied" }, status: :forbidden }
      format.html { redirect_to root_path, alert: "Not authorized" }
    end
  end

  rescue_from Devise::MissingWarden do |_exception|
    render json: { error: "Authentication required" }, status: :unauthorized
  end

  def json_request?
    request.format.json? || request.headers["Accept"]&.include?("application/json")
  end

  # def set_locale
  #   I18n.locale = extract_locale_from_header || I18n.default_locale
  # end

  # def extract_locale_from_header
  #   http_accept_language.compatible_language_from(I18n.available_locales)
  # end
end
