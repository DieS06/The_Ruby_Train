# frozen_string_literal: true

# == HomeController
#
# @!group Controllers / Public
#
# Welcome page (Public HTML).
#
# === Endpoint
# * **GET /** → `#index`
#
# @!endgroup
#

class HomeController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!, only: :index

  def index
    render template: "home/index", formats: [ :html ], layout: "application"
  end
end
