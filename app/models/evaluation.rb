# frozen_string_literal: true

# == Evaluation
#
# @!group 01-Models / Evaluations
#
# Abstract base model for different types of evaluations (quizzes, exams).
#
# === Attributes
# @!attribute [rw] type
#   @return [String] STI type (e.g. "Quiz", "Exam")
# @!attribute [rw] title
#   @return [String] Title of the evaluation
# @!attribute [rw] description
#   @return [Text] Description or instructions
# @!attribute [rw] time_limit
#   @return [Integer] Max duration in minutes (optional)
# @!attribute [rw] state
#   @return [Integer] Enum: draft, active, archived
# @!attribute [rw] content_unit_id
#   @return [Integer] Course or lesson where this evaluation is attached
# @!attribute [rw] created_by
#   @return [Integer] User ID who created it
#
# === Associations
# * belongs_to :content_unit
# * has_one :evaluation_settings
#
# === Methods
# * total_points - Calculates total points from all questions
# * graded? - Returns true if evaluation is graded
# * quiz? - Returns true if evaluation is a quiz
# * exam? - Returns true if evaluation is an exam

#
# === Validations
# * type, title, state presence
#
# @!endgroup
#

class Evaluation < ApplicationRecord
  include StateContent

  belongs_to :content_unit
  belongs_to :creator, class_name: "User", foreign_key: "created_by"

  has_one :evaluation_settings, dependent: :destroy
  can_have_many :evaluation_sections, dependent: :destroy, optional: true
  has_many :questions, dependent: :destroy
  has_many :submissions, dependent: :destroy

  validates :type, presence: true
  validates :title, presence: true
  validates :state, presence: true

  private

  def total_points
    questions.sum(:points)
  end

  def graded?
    submissions.where.not(state: :graded).none?
  end

  def quiz?
    evaluation_type == "Quiz"
  end

  def exam?
    evaluation_type == "Exam"
  end
end
