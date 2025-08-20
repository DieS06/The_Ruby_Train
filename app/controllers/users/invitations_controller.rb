# frozen_string_literal: true

# == Users::InvitationsController
#
# @!group Controllers / Auth
#
# Manages invitations with Devise-Invitable.
#
# === Endpoints
# * **POST /users/invitation**           → `#create`   (send invite)
# * **PUT  /users/invitation**           → `#update`   (accepts invite)
# * **GET  /users/invitation/accept**    → `#edit`
#
# @!endgroup
#

class Users::InvitationsController < ApplicationController
    respond_to :json
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    before_action :authenticate_user!, except: [ :edit, :update ]
    before_action :authorize_invite, only: [ :create ]

    # GET /users/invitation
    def create
      super
    end

    # PUT /users/invitation/accept
    def edit
        super
    end

    # PUT /users/invitation
    def update
      super
    end

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:invite, keys: %i[first_name last_name ])
        devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[ first_name last_name phone_number country ])
    end

    private

    def authorize_invite
        authorize! :invite, User
    end
end
