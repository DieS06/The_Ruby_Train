# frozen_string_literal: true

# == SubmissionMailer
#
# @!group 04-Mailers
#
# Handles emails related to user submissions.
#
# === Methods
# * results_email(submission) – sends results if submission is graded
#
# @!endgroup
#

class SubmissionMailer < ApplicationMailer
  default from: "notificaciones@equixdigital.com"

  def results_email(submission)
    @submission = submission
    @user = submission.user
    @evaluation = submission.evaluation

    mail(
      to: @user.email,
      subject: "Results of your evaluation #{@evaluation.title}"
    )
  end
end
