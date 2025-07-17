# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # USER MUTATIONS
    field :assign_role, mutation: Mutations::User::AssignRole
    field :remove_role, mutation: Mutations::User::RemoveRole
    field :update_profile, mutation: Mutations::User::UpdateProfile

    # CONTENT UNIT MUTATIONS
    field :create_content_unit, mutation: Mutations::ContentUnit::CreateContentUnit

    # TOPIC MUTATIONS
    field :create_topic, mutation: Mutations::Topic::CreateTopic
    field :update_topic, mutation: Mutations::Topic::UpdateTopic
    field :update_state_topic, mutation: Mutations::Topic::UpdateStateTopic
    field :update_position_topic, mutation: Mutations::Topic::UpdatePositionTopic
    field :delete_topic, mutation: Mutations::Topic::DeleteTopic
    # CONTENT TOPIC MUTATIONS
    field :attach_topic_to_content_unit, mutation: Mutations::Topic::AttachTopicToContentUnit
    field :update_state_content_topic, mutation: Mutations::Topic::UpdateStateContentTopic
    field :update_relevance_content_topic, mutation: Mutations::Topic::UpdateRelevanceContentTopic
    field :delete_content_topic, mutation: Mutations::Topic::DeleteContentTopic

    # ENROLLMENT MUTATIONS
    field :create_enrollment, mutation: Mutations::Enrollment::CreateEnrollment
    field :update_state_enrollment, mutation: Mutations::Enrollment::UpdateStateEnrollment
    field :update_progress_percent_enrollment, mutation: Mutations::Enrollment::UpdateProgressPercentEnrollment

    # GROUP MUTATIONS
    field :create_group, mutation: Mutations::Group::CreateGroup
    field :update_group, mutation: Mutations::Group::UpdateGroup
    field :delete_group, mutation: Mutations::Group::DeleteGroup

    # EVALUATION MUTATIONS
    field :create_evaluation, mutation: Mutations::Evaluation::CreateEvaluation
    field :delete_evaluation, mutation: Mutations::Evaluation::DeleteEvaluation
  end
end
