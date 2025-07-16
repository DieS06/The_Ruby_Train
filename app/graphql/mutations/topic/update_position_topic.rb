# frozen_string_literal: true

# == UpdatePositionTopic Mutation
#
# @!group 02-GraphQL / Mutations / Topic
#
# Updates only the `position` of a Topic by ID.
# Useful for controlling hierarchy ordering, often in sync with ContentUnit.
#
# === Arguments
# @!attribute [r] id
#   @return [ID] Required. ID of the topic to update.
# @!attribute [r] position
#   @return [Integer] Required. New position value.
#
# === Returns
# @!attribute [r] topic
#   @return [Types::TopicType] The updated topic with new position.
# @!attribute [r] errors
#   @return [Array<String>] Validation or update errors.
#
# @example GraphQL mutation
#   mutation {
#     updatePositionTopic(id: 1, position: 2) {
#       topic {
#         id
#         position
#       }
#       errors
#     }
#   }
#
# @!endgroup
#
module Mutations
  module Topic
    class UpdatePositionTopic < Base::BaseMutation
      argument :id, ID, required: true
      argument :position, Integer, required: true

      field :topic, Types::Topic::TopicType, null: true
      field :errors, [ String ], null: false

      def resolve(id:, position:)
        topic = ::Topic.find_by(id: id)
        return { topic: nil, errors: [ "Topic not found" ] } unless topic

        if topic.update(position: position)
          { topic: topic, errors: [] }
        else
          { topic: nil, errors: topic.errors.full_messages }
        end
      end
    end
  end
end
