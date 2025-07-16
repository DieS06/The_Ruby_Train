# frozen_string_literal: true

# == UpdateTopic Mutation
#
# @!group 03-GraphQL / Mutations / Topic
#
# Updates a Topic based on ID and provided attributes.
#
# === Arguments
# @!attribute [r] id
#   @return [ID] Required. ID of the topic to update.
# @!attribute [r] name
#   @return [String] Optional. New name for the topic.
# @!attribute [r] description
#   @return [String] Optional. New description.
# @!attribute [r] position
#   @return [Integer] Optional. New position.
# @!attribute [r] parent_id
#   @return [Integer] Optional. New parent topic ID.
# @!attribute [r] state
#   @return [String] Optional. New state (draft, published, etc.)
#
# === Returns
# @!attribute [r] topic
#   @return [Types::TopicType] The updated topic.
# @!attribute [r] errors
#   @return [Array<String>] Validation or update errors, if any.
#
# @example GraphQL mutation
#   mutation {
#     updateTopic(
#       id: 1,
#       name: "Updated Topic"
#     ) {
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
    class UpdateTopic < Base::BaseMutation
      argument :id, ID, required: true
      argument :name, String, required: false
      argument :description, String, required: false
      argument :position, Integer, required: false
      argument :parent_id, ID, required: false
      argument :state, String, required: false

      field :topic, Types::Topic::TopicType, null: true
      field :errors, [ String ], null: false

      def resolve(id:, **attrs)
        topic = ::Topic.find_by(id: id)
        return { topic: nil, errors: [ "Topic not found" ] } unless topic

        if topic.update(attrs)
          { topic: topic, errors: [] }
        else
          { topic: nil, errors: topic.errors.full_messages }
        end
      end
    end
  end
end
