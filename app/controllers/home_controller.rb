class HomeController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!, only: [:index]

  def index
    render "home/index", formats: [:html], layout: "application"
  end
end
