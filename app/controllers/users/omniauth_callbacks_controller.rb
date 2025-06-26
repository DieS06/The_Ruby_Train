# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  def google_oauth2
     @user = User.from_google_omniauth(request.env["omniauth.auth"])

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
       token = Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil)
        render json: {
          message: "Authenticated via Google",
          token: token[0],
          user: UserSerializer.new(@user).as_json
        }, status: :ok
    else
        render json: { error: "Error, your credentials could't be authenticated." }, status: :unauthorized
    end
  end

  protected

  def from_google_params
      auth = request.env["omniauth.auth"]
      {
        uid: auth.uid,
        email: auth.info.email,
        name: auth.info.name,
        provider: auth.provider
      }
  end
end
