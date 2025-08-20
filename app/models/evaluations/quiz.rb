# frozen_string_literal: true

# == Quiz
#
# @!group 01-Models / Evaluations
#
# Represents a lightweight evaluation used for quick testing or practice.
# Inherits from {Evaluation}.
#
# === Usage
# Quiz.create(title: "Ruby Basics", content_unit: lesson, created_by: user.id)
#
# @!endgroup
#

class Evaluations::Quiz < Evaluation
end
