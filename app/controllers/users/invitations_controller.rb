class Users::InvitationsController < ApplicationController
    respond_to :json
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    before_action :configure_permitted_parameters, only: [ :update ]

    def edit
        super
    end

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:invite, keys: [:first_name, :last_name])
        devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :phone_number])
    end
end
