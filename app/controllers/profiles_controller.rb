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
  def index
    render template: "profiles/index", layout: "application"
  end
end
