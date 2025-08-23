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
    @evaluation = Evaluation
      .includes(questions: :answer_options)
      .includes(:evaluation_setting)
      .find(params[:id])
    authorize! :read, current_user
    unless Rules::Gatekeeper.allowed?(current_user, @evaluation)
      redirect_to evaluations_path, alert: "Complete the previous content to get access."
      return
    end
    render template: "evaluations/show", layout: "application"
  end
end
