# frozen_string_literal: true

# == CreateTopic Mutation
#
# @!group 03-GraphQL / Mutations / Topic
#
# Creates a new Topic with provided attributes.
#
# === Arguments
# @!attribute [r] name
#   @return [String] Required. Name of the topic.
# @!attribute [r] description
#   @return [String] Optional. Description of the topic.
# @!attribute [r] position
#   @return [Integer] Required. Position in hierarchy.
# @!attribute [r] parent_id
#   @return [Integer] Optional. ID of parent topic.
# @!attribute [r] state
#   @return [String] Required. State enum (draft, published, etc.)
#
# === Returns
# @!attribute [r] topic
#   @return [Types::TopicType] The newly created topic.
# @!attribute [r] errors
#   @return [Array<String>] List of validation errors, if any.
#
# @example GraphQL mutation
#   mutation {
#     createTopic(input: {
#       name: "Basics",
#       description: "Introductory topics",
#       position: 1,
#       state: "draft"
#     }) {
#       topic {
#         id
#         name
#       }
#       errors
#     }
#   }
#
# @!endgroup
#
module Mutations
  module Topic
    class CreateTopic < Base::BaseMutation
      argument :name, String, required: true
      argument :description, String, required: false
      argument :position, Integer, required: true
      argument :parent_id, ID, required: false
      argument :state, String, required: true

      field :topic, Types::Topic::TopicType, null: true
      field :errors, [ String ], null: false

      def resolve(name:, description: nil, position:, parent_id: nil, state:)
        topic = ::Topic.new(
          name: name,
          description: description,
          position: position,
          parent_id: parent_id,
          state: state
        )

        if topic.save
          { topic: topic, errors: [] }
        else
          { topic: nil, errors: topic.errors.full_messages }
        end
      end
    end
  end
end
