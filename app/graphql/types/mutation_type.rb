# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :update_profile, mutation: Mutations::Profile::UpdateProfile
    field :assign_role, mutation: Mutations::User::AssignRole
  end
end
