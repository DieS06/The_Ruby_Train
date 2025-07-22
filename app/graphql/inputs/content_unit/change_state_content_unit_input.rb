# frozen_string_literal: true

# == ChangeContentUnitStateInput
#
# @!group 02-GraphQL / Inputs / ContentUnit
#
# Input for changing the state of a content unit.
#
# === Fields
# * `id` [ID, required] — ID of the content unit to change.
# * `state` [String, required] — New state (e.g., "draft", "published", "archived", "deleted").
#
# @!endgroup
#

module Inputs
  module ContentUnit
    class ChangeStateContentUnitInput < Types::BaseInputObject
      description "Input for changing the state of a content unit"

      argument :id, ID, required: true
      argument :state, String, required: true
    end
  end
end
