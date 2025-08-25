# frozen_string_literal: true

# == ProfilesController
#
# @!group 01 - Controllers / Users
#
# Delivers the view for React to manage profiles.
#

class ProfilesController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource resource: :profile_page, class: false, only: [ :index ]

  # === Endpoints
  # * **GET /profiles** → `#index`
  def index
    # Authorize the user to read their own profile
    authorize! :read, current_user
    # Rendering of the profile page
    render template: "profiles/index", layout: "application"
  end
end
# @!endgroup
