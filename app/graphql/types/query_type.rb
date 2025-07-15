# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # QUERIES
    # USERS MODULE
    # By_id - Singular
    field :user, resolver: Queries::User::FindUser
    field :role, resolver: Queries::User::FindRole
    field :profile, resolver: Queries::User::FindProfile
    field :my_profile, resolver: Queries::User::MyProfile
    # List - Remember to pluralize the field name
    field :users, resolver: Queries::User::ListUsers
    field :roles, resolver: Queries::User::ListRoles
    field :profiles, resolver: Queries::User::ListProfiles

    # CONTENTS MODULE
    # # By_id - Singular

    # List - Remember to pluralize the field name


    # RESOLVERS
    # EVALUATION MODULE
    # By_id - Singular
    field :evaluation, resolver: Resolvers::Evaluation::FindEvaluation
    # List - Remember to pluralize the field name
    field :evaluations, resolver: Resolvers::Evaluation::ListEvaluations
  end
end
