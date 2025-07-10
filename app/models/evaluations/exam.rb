# frozen_string_literal: true

# == Exam
#
# @!group 01-Models / Evaluations
#
# Represents a formal evaluation (e.g. midterm, final).
# Can include sections via {EvaluationSection}.
#
# === Usage
# Exam.create(title: "Final Exam", content_unit: course, created_by: user.id)
#
# @!endgroup
#

class Evaluations::Exam < Evaluations
end
