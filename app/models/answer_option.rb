# frozen_string_literal: true

# == AnswerOption
#
# @!group 01-Models / Evaluations
#
# Represents a possible answer to a question.
# Used in choice-based question types.
#
# === Attributes
# @!attribute [rw] question_id
#   @return [Integer] Associated question
# @!attribute [rw] option_text
#   @return [String] Answer text visible to the user
# @!attribute [rw] is_correct
#   @return [Boolean] Marks if this option is correct
# @!attribute [rw] explanation
#   @return [Text] Optional explanation for this answer
# @!attribute [rw] position
#   @return [Integer] Display order
#
# @!endgroup
#

class AnswerOption < ApplicationRecord
  belongs_to :question

  validates :option_text, :position, presence: true
  validates :is_correct, inclusion: { in: [ true, false ] }
end
