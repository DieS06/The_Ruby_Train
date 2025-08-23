# frozen_string_literal: true

module Types
  module ContentUnit
    class LessonNavItemType < Types::BaseObject
      description "Lightweight item for lesson nav carousel"
      field :id, ID, null: false
      field :title, String, null: false
      field :slug, String, null: false
    end
  end
end
