# frozen_string_literal: true

# == UpdateContentUnitInput
#
# @!group 02-GraphQL / Inputs / ContentUnit
#
# Input object for updating an existing ContentUnit.
#
# === Fields
# * `id` [ID, required] — ID of the content unit to update.
# * `title` [String, optional] — New title.
# * `slug` [String, optional] — New slug.
# * `description` [String, optional] — New description.
# * `position` [Integer, optional] — Position within the parent.
# * `state` [String, optional] — New state (e.g., draft, published, archived).
#
# === Example
# ```graphql
# input {
#   id: 42,
#   title: "Intro to Ruby",
#   description: "Updated description"
# }
# ```
#
# @!endgroup
#

module Inputs
  module ContentUnit
    class UpdateContentUnitInput < Types::BaseInputObject
      description "Attributes for updating a ContentUnit"

      argument :id, ID, required: true
      argument :title, String, required: false
      argument :slug, String, required: false
      argument :description, String, required: false
      argument :position, Integer, required: false
      argument :state, String, required: false
      argument :lock_expire_at, GraphQL::Types::ISO8601DateTime, required: false
      argument :parent_id, ID, required: false
    end
  end
end
