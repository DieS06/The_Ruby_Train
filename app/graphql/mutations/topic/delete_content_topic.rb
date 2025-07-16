# frozen_string_literal: true

# == DeleteContentTopic Mutation
#
# @!group 03-GraphQL / Mutations / ContentTopic
#
# Deletes a specific ContentTopic relation.
#
# === Arguments
# @!attribute [r] id
#   @return [ID] ID of the ContentTopic to delete.
#
# === Returns
# @!attribute [r] success
#   @return [Boolean] Whether the deletion was successful.
# @!attribute [r] errors
#   @return [Array<String>] Any error messages if deletion failed.
#
# @example
#   mutation {
#     deleteContentTopic(id: 3) {
#       success
#       errors
#     }
#   }
#
# @!endgroup
#
module Mutations
  module Topic
    class DeleteContentTopic < Base::BaseMutation
      argument :id, ID, required: true

      field :success, Boolean, null: false
      field :errors, [ String ], null: false

      def resolve(id:)
        content_topic = ::ContentTopic.find_by(id: id)

        return { success: false, errors: [ "Not found" ] } unless content_topic

        if content_topic.destroy
          { success: true, errors: [] }
        else
          { success: false, errors: content_topic.errors.full_messages }
        end
      end
    end
  end
end
