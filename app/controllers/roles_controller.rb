# frozen_string_literal: true

# == RolesController
#
# @!group Controllers / Admin
#
# Delivers the view for React to manage roles.
#
# === Endpoints
# * **GET  /users/:user_id/roles** → `#index`
#
# @!endgroup
#

class RolesController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: false

  def index
    render template: "roles/index", formats: [ :html ], layout: "application"
  end
end
