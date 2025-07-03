module Types
    module User
        class UserType < Types::BaseObject
            field :id, ID, null: false
            field :email, String, null: false
            field :first_name, String, null: false, camelize: false
            field :last_name, String, null: false, camelize: false
            field :country, String, null: false
            field :phone_number, String, null: false, camelize: false
            field :state, String, null: false

            field :created_at, GraphQL::Types::ISO8601DateTime, null: false, camelize: false
            field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, camelize: false

            field :reset_password_sent_at, GraphQL::Types::ISO8601DateTime, null: true, camelize: false

            field :invitation_created_at, GraphQL::Types::ISO8601DateTime, null: true, camelize: false
            field :invitation_sent_at, GraphQL::Types::ISO8601DateTime, null: true, camelize: false
            field :invitation_accepted_at, GraphQL::Types::ISO8601DateTime, null: true, camelize: false
            field :invited_by_type, String, null: true, camelize: false
            field :invited_by_id, ID, null: true, camelize: false
            field :invitations_count, Int, null: true, camelize: false

            field :confirmed_at, GraphQL::Types::ISO8601DateTime, null: true, camelize: false
            field :confirmation_sent_at, GraphQL::Types::ISO8601DateTime, null: true, camelize: false
            field :unconfirmed_email, String, null: true, camelize: false

            field :provider, String, null: true
            field :uid, String, null: true

            field :roles, [ Types::User::RoleType ], null: false
            field :role_names, [ String ], null: false, method: :role_names, description: "List of role names assigned to the user"
            field :profile, Types::User::ProfileType, null: false

            def role_names
                object.roles.map(&:name)
            end

            def full_name
                object.full_name
            end
        end
    end
end
