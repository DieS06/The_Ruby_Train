# frozen_string_literal: true

# == RolesController
#
# @!group 01 - Controllers / Admin
#
# Delivers the view for React to manage roles.
#

class RolesController < ApplicationController
  # * Local authentication with no Active Record class (`authenticate_user!`)
  before_action :authenticate_user!
  authorize_resource class: false

  # === Endpoints
  # * **GET  /users/:user_id/roles** → `#index`
  def index
    render template: "roles/index", formats: [ :html ], layout: "application"
  end
end
# @!endgroup
