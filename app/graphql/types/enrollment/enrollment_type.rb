module Types
  module Enrollment
    class EnrollmentType < Types::BaseObject
      field :id, ID, null: false
      field :user_id, ID, null: false
      field :content_unit_id, ID, null: false
      field :state, String, null: false
      field :progress_percent, Float, null: false
      field :enrolled_at, GraphQL::Types::ISO8601DateTime, null: false
      field :completed_at, GraphQL::Types::ISO8601DateTime, null: true

      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      field :user, Types::User::UserType, null: false
      field :content_unit, Types::Interfaces::ContentUnitInterface, null: false
    end
  end
end
