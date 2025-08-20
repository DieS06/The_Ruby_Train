# frozen_string_literal: true

# == Ability
#
# @!group 01-Authorization / CanCan
#
# Central authorization rules using CanCanCan.
#
# === Role Permissions Summary
#
# * **super_admin** → Full access to all models and actions.
# * **admin** → Manage all evaluation content, groups, enrollments, roles, and badges.
# * **academy** → Limited management of own groups, evaluations, and reading access to related data.
# * **mentor** → Read and update access for groups and evaluation data within assigned courses.
# * **student** → Can read and submit within enrolled courses only.
#
# === Access Levels
#
# * `:read` → Viewing only
# * `:create` → Adding new records
# * `:update` → Editing own records
# * `:destroy` → Deleting (with soft-delete protection elsewhere)
# * `:archive` → Soft-deactivation or lock to updates (e.g., on published courses/evaluations)
#
# === Shared Helpers
#
# * `has_access_to_course?(content_unit_id)` → Checks if user (mentor/academy/student) has course access through a group.
#
# @!endgroup
#

class Ability
  include CanCan::Ability

  def initialize(user)
    # ─── CONTENT UNITS ───────────────────────────
    can :read, ContentUnit, state: "visible"

    return unless user.present?

    can :read, :profile_page
    can :update, ::User, id: user.id

    define_singleton_method(:has_access_to_course?) do |content_unit_id|
      GroupCourse.exists?(content_unit_id:, group_id: user.assigned_groups.ids)
    end

    # ─── SUPER ADMIN ─────────────────────────────
    if user.has_role?(:super_admin)
      can :manage, :all
      return
    end

    # ─── ADMIN ───────────────────────────────────
    if user.has_role?(:admin)
      can :invite, User
      can :assign_role, User
      can :remove_role, User

      can :manage, [ Topic, ContentTopic, Enrollment, Group, Evaluation, Question, AnswerOption, Submission, ContentUnit, Badge, UserBadge, Progress ]
      # can :manage, ContentUnit::GroupCourse::GroupMembership

      can [ :read, :update ], EvaluationSetting
      can [ :read, :create, :update, :destroy ], EvaluationSection
      can :archive, [ Evaluation, ContentUnit ]
    end

    # ─── ACADEMY ────────────────────────────────
    if user.has_role?(:academy)
      can :invite, User
      can :assign_role, User
      can :remove_role, User

      can [ :create ], Group
      can [ :update, :read ], Group, created_by: user.id
      can [ :create, :read, :update ], Enrollment, user_id: user.id

      can [ :read, :create, :update ], Evaluation, created_by: user.id
      can [ :read, :update ], EvaluationSetting do |setting|
        setting.evaluation.created_by == user.id
      end
      can [ :read, :create, :update, :destroy ], EvaluationSection do |section|
        section.evaluation.created_by == user.id
      end

      can [ :read, :create, :update ], Question do |question|
        has_access_to_course?(question.evaluation.content_unit_id)
      end
      can [ :read, :update, :destroy ], Question, created_by: user.id

      can :read, AnswerOption do |answer_option|
        has_access_to_course?(answer_option.question.evaluation.content_unit_id)
      end

      can [ :read ], Submission do |submission|
        has_access_to_course?(submission.evaluation.content_unit_id)
      end

      can [ :read ], SubmissionAnswer do |answer|
        has_access_to_course?(answer.submission.evaluation.content_unit_id)
      end

      can [ :read ], Badge, state: "visible"
      can [ :read ], UserBadge do |user_badge|
        GroupMembership.exists?(user_id: user_badge.user_id, group_id: user.assigned_groups.ids)
      end
      can [ :read ], Progress do |progress|
        has_access_to_course?(progress.content_unit_id)
      end
    end

    # ─── MENTOR ──────────────────────────────────
    if user.has_role?(:mentor)
      can :invite, User # solo como student (validado en lógica externa)
      can :manage, Group, id: user.assigned_groups.ids

      can [ :read, :create, :update ], Evaluation, created_by: user.id
      can [ :read, :update ], EvaluationSetting do |setting|
        setting.evaluation.created_by == user.id
      end
      can [ :read, :create, :update, :destroy ], EvaluationSection do |section|
        section.evaluation.created_by == user.id
      end

      can [ :read, :create, :update ], Question do |question|
        has_access_to_course?(question.evaluation.content_unit_id)
      end
      can [ :read, :update, :destroy ], Question, created_by: user.id

      can :read, AnswerOption do |answer_option|
        has_access_to_course?(answer_option.question.evaluation.content_unit_id)
      end

      can [ :read ], Submission do |submission|
        has_access_to_course?(submission.evaluation.content_unit_id)
      end

      can [ :read ], SubmissionAnswer do |answer|
        has_access_to_course?(answer.submission.evaluation.content_unit_id)
      end

      can [ :read ], Badge, state: "visible"
      can [ :read ], UserBadge do |user_badge|
        GroupMembership.exists?(user_id: user_badge.user_id, group_id: user.assigned_groups.ids)
      end
      can [ :read ], Progress do |progress|
        has_access_to_course?(progress.content_unit_id)
      end
    end

    # ─── STUDENT ─────────────────────────────────
    if user.has_role?(:student)
      can [ :read ], Group, id: user.assigned_groups.ids
      can [ :create, :read ], Enrollment, user_id: user.id

      can [ :read ], User,   id: user.id
      can [ :read ], Profile, user_id: user.id

      can [ :read ], Evaluation, state: "visible"
      can [ :read ], Question do |question|
        user.enrollments.exists?(content_unit_id: question.evaluation.content_unit_id)
      end
      can [ :read ], AnswerOption do |answer_option|
        user.enrollments.exists?(content_unit_id: answer_option.question.evaluation.content_unit_id)
      end

      can [ :create, :read ], Submission, user_id: user.id
      can :read, SubmissionAnswer do |answer|
        answer.submission.user_id == user.id
      end

      can [ :read ], Badge, state: "visible"
      can [ :read ], UserBadge, user_id: user.id
      can [ :read ], Progress, user_id: user.id
    end

    # ─── TOPICS ──────────────────────────────────
    can [ :read ], Topic, state: "visible"
    can [ :create, :update, :destroy ], Topic, created_by: user.id if user.has_role?(:admin) || user.has_role?(:super_admin)

    can [ :read ], ContentTopic, state: "visible"
    can [ :create, :update, :destroy ], ContentTopic do |ct|
      (user.has_role?(:admin) || user.has_role?(:super_admin)) && ct.content_unit&.created_by == user.id
    end
  end
end
