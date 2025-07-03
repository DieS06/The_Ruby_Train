module Types
    module User
        class RoleType < Types::BaseObject
            field :id, ID, null: false
            field :name, String, null: false
            field :resource_type, String, null: true
            field :resource_id, ID, null: true
            field :created_at, GraphQL::Types::ISO8601DateTime, null: false
            field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
        end
    end
end