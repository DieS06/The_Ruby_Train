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
  skip_before_action :authenticate_user!, only: :index
  skip_authorization_check

  def index
    render template: "profiles/index", layout: "application"
  end
end
