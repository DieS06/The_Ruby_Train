# frozen_string_literal: true

# == HomeController
#
# @!group 01 - Controllers / Public
#
# Welcome page (Public HTML).

class HomeController < ApplicationController
  # * Index local authorization (CanCanCan `check_authorization`)
  skip_before_action :authenticate_user!, only: :index

  # === Endpoint
  # * **GET /** → `#index`
  def index
    # Rendering of the home page with HTML format
    render template: "home/index", formats: [ :html ], layout: "application"
  end
end
# @!endgroup
