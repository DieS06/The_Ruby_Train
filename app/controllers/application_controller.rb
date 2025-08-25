# frozen_string_literal: true

# == ApplicationController
#
# @!group 01 - Controllers / Base
#
# Root controller that manages:
#

class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  include CanCan::ControllerAdditions
  # * CSRF protection from invalid tokens
  protect_from_forgery with: :exception
  # * Global authentication (`authenticate_user!`)
  before_action :authenticate_user!, unless: :devise_controller?
  # * Global authorization (CanCanCan `check_authorization`)
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      # * JSON and HTML errors handling (`AccessDenied` & `Not authorized`)
      format.json { render json: { error: "Access Denied" }, status: :forbidden }
      format.html { redirect_to root_path, alert: "Not authorized" }
    end
  end
end
# @!endgroup
