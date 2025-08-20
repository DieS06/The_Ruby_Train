# frozen_string_literal: true

# == EvaluationSection
#
# @!group 01-Models / Evaluations
#
# Optional section within an Exam. Useful to organize large evaluations.
#
# === Attributes
# @!attribute [rw] evaluation_id
#   @return [Integer] Associated Exam
# @!attribute [rw] title
#   @return [String] Section title
# @!attribute [rw] description
#   @return [Text] Optional section description
# @!attribute [rw] position
#   @return [Integer] Display order in the exam
# @!attribute [rw] time_limit
#   @return [Integer] Time limit for this section (optional, overrides global)
#

class EvaluationSection < ApplicationRecord
  belongs_to :evaluation, optional: true

  validates :title, :position, presence: true
  validates :position, numericality: { only_integer: true, greater_than: 0 }
  validates :time_limit, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
