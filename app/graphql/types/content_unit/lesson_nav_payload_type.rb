# frozen_string_literal: true

module Types
  module ContentUnit
    class LessonNavPayloadType < Types::BaseObject
      description "Payload for lesson nav (prev/current/next + quiz)"
      field :items, [ LessonNavItemType ], null: false
      field :current_index, Integer, null: false
      field :quiz_id, ID, null: true
    end
  end
end
