# frozen_string_literal: true

# == Submission
#
# @!group 01-Models / Evaluations
#
# Represents a user's submission to an evaluation (quiz or exam).
#
# === Attributes
# @!attribute [rw] user_id
#   @return [Integer] The user who submitted
# @!attribute [rw] evaluation_id
#   @return [Integer] Evaluation being submitted
# @!attribute [rw] submitted_at
#   @return [DateTime] When the evaluation was submitted
# @!attribute [rw] score
#   @return [Integer] Final score (optional until graded)
# @!attribute [rw] feedback
#   @return [Text] General comments from reviewers
# @!attribute [rw] state
#   @return [Integer] Enum: draft, submitted, graded, rejected
#
# === Methods
# @!method finalize!
#   Marks the submission as finalized by setting the `submitted_at` timestamp and updating the state to `submitted`.
#
# @!method calculate_score!
#   Computes the final score by summing the points of correctly answered questions.
#
# @!method graded?
#   @return [Boolean] Whether the submission has been graded (`state == "graded"`).
#
# @!method completed?
#   @return [Boolean] Whether the submission has been completed (submitted or graded).
#
# @!method auto_grade_all!
#   Automatically grades all answers in the submission. If any require manual review, sets the flag and skips scoring.
#
# @see SubmissionAnswer
# @see Evaluation
# @see User
#
# @!endgroup
#

class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :evaluation

  has_many :submission_answers, dependent: :destroy

  enum :state, {
    open: 0,
    submitted: 1,
    graded: 2,
    closed: 3,
    rejected: 4
  }

  validates :state, presence: true
  validates :score, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def finalize!
    update!(submitted_at: Time.current, state: :submitted)
  end

  def calculate_score!
    update!(
      score: submission_answers.includes(:question).select(&:is_correct).sum { |a| a.question.points }
    )
  end

  def graded?
    state == "graded"
  end

  def completed?
    submitted_at.present?
  end

  def auto_grade_all!
    requires_manual = false
    total_score = 0

    submission_answers.includes(:question, :answer_option).find_each do |answer|
      answer.auto_grade!
      requires_manual ||= answer.is_correct.nil?
      total_score += answer.question.points if answer.is_correct == true
    end

    if requires_manual
      update!(manual_review_required: true)
    else
      update!(score: total_score, state: "graded", graded: true)
    end
  end
end
