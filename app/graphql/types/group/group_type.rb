# frozen_string_literal: true

# == GroupType
#
# @!group 02-GraphQL / Types / Group
#
# GraphQL type definition for the Group model.
#
# === Fields
# @!attribute [r] id
#   @return [ID] Unique identifier for the group.
# @!attribute [r] name
#   @return [String] Name of the group.
# @!attribute [r] description
#   @return [String] Optional description of the group.
# @!attribute [r] group_type
#   @return [String] Enum: mentor_group, academic_group, special_group, other.
# @!attribute [r] mentor_id
#   @return [Integer] ID of the assigned mentor (User).
# @!attribute [r] academic_id
#   @return [Integer] ID of the assigned academic advisor (User).
# @!attribute [r] state
#   @return [String] Enum: draft, published, archived.
# @!attribute [r] slug
#   @return [String] Unique system slug used for URLs.
# @!attribute [r] created_at
#   @return [GraphQL::Types::ISO8601DateTime] Timestamp of creation.
# @!attribute [r] updated_at
#   @return [GraphQL::Types::ISO8601DateTime] Timestamp of last update.
#
# @example GraphQL query
#   {
#     groups {
#       id
#       name
#       groupType
#       state
#       slug
#     }
#   }
#
# @!endgroup
#

module Types
  module Group
    class GroupType < Types::BaseObject
      field :id, ID, null: false
      field :name, String, null: false
      field :description, String, null: true
      field :group_type, String, null: false
      field :mentor_id, Integer, null: true
      field :academic_id, Integer, null: true
      field :state, String, null: false
      field :slug, String, null: false

      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    end
  end
end
