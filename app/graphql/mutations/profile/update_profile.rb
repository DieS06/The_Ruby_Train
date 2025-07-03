module Mutationste
    module Profile
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
                field :errors, [String], null: false

                def resolve (
                    bio: nil,
                    linkedin_url: nil,
                    github_url: nil,
                    website_url: nil,
                    location: nil,
                    company_name: nil,
                    job_title: nil
                )

                current_user = context[:current_user]

                unless current_user
                    raise GraphQL::ExecutionError, "Authentication required to update profile."
                end

                profile = current_user.profile
                unless profile
                    raise GraphQL::ExecutionError, "Profile not found for the current user."
                end

                unless context[:current_user].can?(:update, profile)
                    raise GraphQL::ExecutionError, "You are not authorized to update this profile."
                end

                profile_attributes = {
                    bio: bio,
                    linkedin_url: linkedin_url,
                    github_url: github_url,
                    website_url: website_url,
                    location: location,
                    company_name: company_name,
                    job_title: job_title
                }.compact

                if profile.update(profile_attributes)
                    { profile: profile, errors: [] }
                else
                    { profile: nil, errors: profile.errors.full_messages }
                end
            rescue => e
                Rails.logger.error("Error updating profile: #{e.message}")
                {profile: nil, errors: ["An unexpected error occurred while updating the profile."]}
            end
        end
    end
end

          