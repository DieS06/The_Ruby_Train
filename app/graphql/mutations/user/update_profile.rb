module Mutations
    module User
        class UpdateProfile < Mutations::Base::BaseMutation
            description "Update the current user's profile."

            argument :bio, String, required: false
            argument :linkedin_url, String, required: false, camelize: false
            argument :github_url, String, required: false, camelize: false
            argument :website_url, String, required: false, camelize: false
            argument :location, String, required: false
            argument :company_name, String, required: false, camelize: false
            argument :job_title, String, required: false, camelize: false

            field :profile, Types::User::ProfileType, null: true
            field :errors, [ String ], null: false

            def resolve(**attributes)
                current_user = context[:current_user]
                raise GraphQL::ExecutionError, "Authentication required." unless current_user

                profile = current_user.profile
                raise GraphQL::ExecutionError, "Profile not found." unless profile

                ability = Ability.new(current_user)
                raise GraphQL::ExecutionError, "Unauthorized" unless ability.can?(:update, profile)

                if profile.update(attributes.compact)
                { profile: profile, errors: [] }
                else
                { profile: nil, errors: profile.errors.full_messages }
                end
            rescue => e
                Rails.logger.error("UpdateProfile error: #{e.class.name} - #{e.message}")
                Rails.logger.error(e.backtrace.join("\n"))
                { profile: nil, errors: [ e.message ] }
            end
        end
    end
end
