# frozen_string_literal: true

# == ContentUnitsController
#
# @!group Controllers / Content
#
# ContentUnitsController manages the content units in the system.
#
# === Endpoints
# * **GET /content_units** → `#index`
#
# @!endgroup
#

class ContentUnitsController < ApplicationController
  def index
    render template: "content_units/index", layout: "application"
  end
end
