# frozen_string_literal: true

# == AutoGradeSubmissionJob
#
# @!group 06-Background Jobs
#
# This job performs automatic grading for a submission.
# It iterates over each answer, calls `auto_grade!` on them,
# and updates the submission's score and status accordingly.
#
# === Parameters
# @param [Integer] submission_id ID of the submission to be graded
#
# === Side Effects
# Updates `score`, `graded`, and `submitted_at` fields in the Submission.
# Can mark submission for manual review if required.
#
# === See Also
# @see SubmissionAnswer#auto_grade!
# @see Submission#question_points
#
# @!endgroup
#

class AutoGradeSubmissionJob < ApplicationJob
  queue_as :default

  def perform(submission_id)
    submission = Submission.find(submission_id)

    Submission.transaction do
      submission.submission_answers.includes(:question, :answer_option).each do |answer|
        answer.auto_grade!
      end

      submission.update!(
        score: submission.submission_answers.where(is_correct: true).sum(&:question_points),
        graded: true,
        submitted_at: Time.current
      )
    end
  end
end
