# frozen_string_literal: true

class Api::SubmissionsController < ApplicationController
  before_action :authenticate_user!

  def create
    evaluation = Evaluation.includes(
      :evaluation_setting,
      questions: :answer_options
    ).find(
      submit_params[:evaluation_id]
    )

    authorize! :read, evaluation

    if evaluation.type == "Quiz" && evaluation.content_unit&.type == "Segment"
      gate = ProgressionPolicy.for(user: current_user, segment: evaluation.content_unit)
      return render json: { error: "locked" }, status: :forbidden if gate[:state] == :locked
    end

    unless Rules::Gatekeeper.allowed?(current_user, evaluation)
      return render json: { error: "forbidden" }, status: :forbidden
    end

    submission = Submission.create!(
      user: current_user,
      evaluation:,
      submitted_at: Time.current,
      state: 0
    )

    total_points = 0
    earned_points = 0
    by_q = (submit_params[:answers] || []).index_by { |a| a[:question_id].to_i }

     evaluation.questions.order(:position).each do |q|
      total_points += q.points
      chosen = Array(by_q[q.id]&.dig(:answer_option_ids)).map(&:to_i)
      chosen.each do |opt_id|
        SubmissionAnswer.create!(submission:, question_id: q.id, answer_option_id: opt_id)
      end
      correct_ids = q.answer_options.where(is_correct: true).pluck(:id).sort
      earned_points += q.points if chosen.sort == correct_ids
    end

    score = total_points.zero? ? 0 : ((earned_points * 100.0) / total_points).round
    submission.update!(score:, state: 1)

    cfg = evaluation.evaluation_setting&.config || {}
    pass = cfg["pass_score"] || (evaluation.type == "Exam" ? 80 : 60)
    passed = cfg["advance_only"] ? (earned_points.positive?) : (score >= pass)

    if passed && evaluation.content_unit
      pr = Progress.find_or_initialize_by(user: current_user, content_unit: evaluation.content_unit)
      pr.progress_percentage = 100
      pr.state = 1 if pr.has_attribute?(:state)
      pr.completed_at ||= Time.current
      pr.save!
    end
   BadgeAssigner.new(current_user).call

    render json: { submission_id: submission.id, score:, passed: passed }, status: :created
  end

  private

  def submit_params
    params.require(:submission).permit(:evaluation_id, answers: [ :question_id, { answer_option_ids: [] } ])
  end
end
