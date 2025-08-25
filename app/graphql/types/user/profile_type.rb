module Types
    module User
        class ProfileType < Types::BaseObject
            field :id, ID, null: false
            field :bio, String, null: true
            field :linkedin_url, String, null: true
            field :github_url, String, null: true
            field :website_url, String, null: true
            field :location, String, null: true
            field :company_name, String, null: true
            field :job_title, String, null: true

            field :created_at, GraphQL::Types::ISO8601DateTime, null: false
            field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

            field :user_id, ID, null: false
            field :user, Types::User::UserType, null: false
        end
    end
end
