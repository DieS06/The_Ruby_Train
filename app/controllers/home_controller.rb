class HomeController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!, only: [:index]

  def index
    render layout: "application"
  end
end
