# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :users, [Type::User::UserType], null: false do
      description "Returns a list of all users, with optional pagination."
      argument :page, Int, required: false, default_value: 1
      argument :per_page, Int, required: false, default_value: 10
    end

    def users (page:, per_page:)
      unless context[:current_user]&.has_role?(:admin) || context[:current_user]&.has_role?(:super_admin)
        raise GraphQL::ExecutionError, "You are not authorized to access the list of users."
      end

      User.all.page(page).per(per_page)
    rescue => e
        Rails.logger.error("Error fetching all_users: #{e.message}")
        raise GraphQL::ExecutionError, "Failed to fetch users: #{e.message}"
    end

    field :my_profile, Types::User::ProfileType, null: true do
      description "Returns the current authenticated user's profile."
    end
    
    def my_profile
      current_user = context[:current_user]
      unless current_user
        raise GraphQL::ExecutionError, "You must be logged in to access this field."
      end
      current_user.profile
    rescue => e
        Rails.logger.error("Error fetching my_profile: #{e.message}")
        raise GraphQL::ExecutionError, "Failed to fetch your profile: #{e.message}"
    end

  end
end
