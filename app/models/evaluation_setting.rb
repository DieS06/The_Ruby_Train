# == EvaluationSetting
#
# @!group 01-Models / Evaluations
#
# Settings for an evaluation (Quiz or Exam).
# Controls logic like number of attempts, result visibility, etc.
#
# === Attributes
# @!attribute [rw] evaluation_id
#   @return [Integer] Reference to associated Evaluation
# @!attribute [rw] attempts_allowed
#   @return [Integer] Max number of attempts allowed (optional)
# @!attribute [rw] shuffle_questions
#   @return [Boolean] Whether to shuffle questions
# @!attribute [rw] show_results
#   @return [Boolean] Whether to show score after submission
# @!attribute [rw] show_feedback
#   @return [Boolean] Whether to show answer explanations
# @!attribute [rw] config
#   @return [JSONB] Optional additional settings
#
# === Validations
# @!attribute [rw] attempts_allowed
#   @return [Integer] Must be a non-negative integer if set
# @!attribute [rw] shuffle_questions, show_results, show_feedback
#   @return [Boolean] Must be true or false
#
# === Associations
# @!attribute [rw] evaluation
#   @return [Evaluation] The associated evaluation
#
# @see Evaluation
#
# @!endgroup

class EvaluationSetting < ApplicationRecord
  belongs_to :evaluation

  validates :attempts_allowed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :shuffle_questions, :show_results, :show_feedback, inclusion: { in: [ true, false ] }
end
