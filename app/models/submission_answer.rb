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
# === Methods
# @!method auto_grade!
#   Grades the answer automatically based on the question type.
#   For single_choice and true_false, checks if the selected option is correct.
#   For other types, marks the submission as requiring manual review.
#
# @!method question_points
#   @return [Integer] Points associated with the related question (0 if unavailable).
#
# @see Submission
# @see Question
# @see AnswerOption
#
# @!endgroup

class SubmissionAnswer < ApplicationRecord
  belongs_to :submission
  belongs_to :question
  belongs_to :answer_option, optional: true

  validates :is_correct, inclusion: { in: [ true, false ] }, allow_nil: true

  def auto_grade!
    case question.question_type
    when "single_choice", "true_false"
      self.is_correct = answer_option&.is_correct
    when "multiple_choice"
      submission.update!(manual_review_required: true)
      return
    when "text_input"
      submission.update!(manual_review_required: true)
      return
    else
      submission.update!(manual_review_required: true)
      return
    end

    save!
  end

  def question_points
    question&.points.to_i
  end
end
