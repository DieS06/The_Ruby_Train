module Mutations
  module User
    class AssignRole < Mutations::Base::BaseMutation
      description "Assigns a role to a user"

      argument :user_id, ID, required: true
      argument :role_name, String, required: true

      field :user, Types::User::UserType, null: true
      field :errors, [ String ], null: false

      def resolve(user_id:, role_name:)
        admin = context[:current_user]
        raise GraphQL::ExecutionError, "Unauthorized" unless admin.has_role?(:admin) || admin.has_role?(:super_admin)

        user = ::User.find_by(id: user_id)
        raise GraphQL::ExecutionError, "User not found" unless user

        if user.add_role(role_name)
          { user: user, errors: [] }
        else
          { user: nil, errors: [ "Failed to assign role" ] }
        end
      rescue => e
        Rails.logger.error("AssignRole error: #{e.message}")
        { user: nil, errors: [ "Unexpected error: #{e.message}" ] }
      end
    end
  end
end
