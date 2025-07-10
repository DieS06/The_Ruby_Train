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

class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :evaluation

  has_many :submission_answers, dependent: :destroy

  enum state: {
    open: 0,
    submitted: 1,
    graded: 2,
    closed: 3,
    rejected: 4
  }

  validates :state, presence: true
  validates :score, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def finaliza!
  end

  def calculate_score!
  end

  def graded?
  end

  def completed?
  end
end
