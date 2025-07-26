# frozen_string_literal: true

# == ProfilesController
#
# @!group Controllers / Users
#
# Delivers the view for React to manage profiles.
#
# === Endpoints
# * **GET /profiles** → `#index`
#
# @!endgroup
#

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource class: false, only: [ :index ]

  def index
    render template: "profiles/index", layout: "application"
  end
end
