# frozen_string_literal: true

# == SubmissionAnswer
#
# @!group 01-Models / Evaluations
#
# Represents an individual answer submitted by a user for a given question.
#
# === Attributes
# @!attribute [rw] submission_id
#   @return [Integer] Reference to the user's submission
# @!attribute [rw] question_id
#   @return [Integer] Question being answered
# @!attribute [rw] answer_option_id
#   @return [Integer] Selected answer option (if applicable)
# @!attribute [rw] text_answer
#   @return [Text] Free-text answer (for open questions)
# @!attribute [rw] is_correct
#   @return [Boolean] Whether the answer was correct
#

class SubmissionAnswer < ApplicationRecord
  belongs_to :submission
  belongs_to :question
  belongs_to :answer_option

  validates :is_correct, inclusion: { in: [ true, false ] }, allow_nil: true

  def auto_grade!
  end
end
