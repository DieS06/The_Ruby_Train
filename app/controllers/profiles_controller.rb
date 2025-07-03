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
  skip_authorization_check
  skip_before_action :authenticate_user!, only: :index

  def index
    render template: "profiles/index", formats: [ :html ], layout: "application"
  end
end
