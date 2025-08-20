class CustomFailure < Devise::FailureApp
  def redirect_url
    Rails.logger.debug "[CUSTOM FAILURE] redirect_url llamado"
    root_path(notice: "session_expired")
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
