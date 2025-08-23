# frozen_string_literal: true

module Api
  # == Api::EvaluationsController
  #
  # @!group API / Evaluations
  # * GET /api/evaluations/:id — Returns one evaluation with questions, options and settings.
  # @!endgroup
  class EvaluationsController < ApplicationController
    before_action :authenticate_user!

    # GET /api/evaluations/:id
    # @return [JSON] evaluation payload for the quiz/exam runner
    def show
      evaluation = Evaluation
        .includes(questions: :answer_options)
        .includes(:evaluation_setting)
        .find(params[:id])

      authorize! :read, evaluation

      allow =
        current_user.has_role?(:super_admin) ||
        (evaluation.type == "Quiz") ||
        Rules::Gatekeeper.allowed?(current_user, evaluation)

      unless allow
        head :forbidden and return
      end

      render json: serialize_evaluation(evaluation)
    end

    private

    def serialize_evaluation(e)
      {
        id: e.id,
        type: e.type,
        title: e.title,
        description: e.description,
        time_limit: e.time_limit,
        content_unit_id: e.content_unit_id,
        settings: (e.evaluation_setting && {
          attempts_allowed: e.evaluation_setting.attempts_allowed,
          shuffle_questions: e.evaluation_setting.shuffle_questions,
          show_results: e.evaluation_setting.show_results,
          show_feedback: e.evaluation_setting.show_feedback,
          config: e.evaluation_setting.config
        }),
        questions: e.questions.order(:position).map do |q|
          {
            id: q.id,
            statement: q.statement,
            question_type: q.question_type,
            position: q.position,
            points: q.points,
            explanation: q.explanation,
            options: q.answer_options.order(:position).map do |opt|
              {
                id: opt.id,
                text: opt.option_text,
                position: opt.position
              }
            end
          }
        end
      }
    end
  end
end
