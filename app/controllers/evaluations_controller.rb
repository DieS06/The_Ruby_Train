# frozen_string_literal: true

# == EvaluationController
#
# @!group Controllers / Evaluations
#
# Delivers the view for React to manage evaluations.
#
# === Endpoints
# * **GET /evaluations** → `#index`
#
# @!endgroup
#

class EvaluationsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource resource: :profile_page, class: false, only: [ :index ]

  def index
    authorize! :read, current_user
    render template: "evaluations/index", layout: "application"
  end

  def show
    authorize! :read, current_user
    @evaluation = Evaluation.find(params[:id])
    render template: "evaluations/show", layout: "application"
  end
end
