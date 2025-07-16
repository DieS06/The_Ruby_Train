# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # USER MUTATIONS
    field :assign_role, mutation: Mutations::User::AssignRole
    field :remove_role, mutation: Mutations::User::RemoveRole
    field :update_profile, mutation: Mutations::User::UpdateProfile
    # ENROLLMENT MUTATIONS
    field :create_enrollment, mutation: Mutations::Enrollment::CreateEnrollment
    field :update_state_enrollment, mutation: Mutations::Enrollment::UpdateStateEnrollment
    field :update_progress_percent_enrollment, mutation: Mutations::Enrollment::UpdateProgressPercentEnrollment
    # CONTENT UNIT MUTATIONS
    field :create_content_unit, mutation: Mutations::ContentUnit::CreateContentUnit

    # EVALUATION MUTATIONS
    field :create_evaluation, mutation: Mutations::Evaluation::CreateEvaluation
    field :delete_evaluation, mutation: Mutations::Evaluation::DeleteEvaluation
  end
end
