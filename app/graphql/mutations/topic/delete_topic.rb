# frozen_string_literal: true

# == DeleteTopic Mutation
#
# @!group 03-GraphQL / Mutations / Topic
#
# Deletes a topic by its ID. You can later customize this to perform soft-delete (`state: "deleted"`).
#
# === Arguments
# @!attribute [r] id
#   @return [ID] Required. ID of the topic to delete.
#
# === Returns
# @!attribute [r] success
#   @return [Boolean] True if deletion was successful.
# @!attribute [r] errors
#   @return [Array<String>] Errors if deletion failed.
#
# @example GraphQL mutation
#   mutation {
#     deleteTopic(id: 1) {
#       success
#       errors
#     }
#   }
#
# @!endgroup
#
module Mutations
  module Topic
    class DeleteTopic < Base::BaseMutation
      argument :id, ID, required: true

      field :success, Boolean, null: false
      field :errors, [ String ], null: false

      def resolve(id:)
        topic = ::Topic.find_by(id: id)
        return { success: false, errors: [ "Topic not found" ] } unless topic

        if topic.destroy
          { success: true, errors: [] }
        else
          { success: false, errors: topic.errors.full_messages }
        end
      end
    end
  end
end
