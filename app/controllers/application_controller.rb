class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  include CanCan::ControllerAdditions
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  before_action :authenticate_user!
  
  check_authorization unless: :devise_controller?

  allow_browser versions: :modern

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

  def authenticate_user!
    if json_request?
      unless current_user
        render json: { error: "Authentication failed" }, status: :unauthorized
      end
    else
      super
    end
  end
end
