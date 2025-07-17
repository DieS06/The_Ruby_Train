# frozen_string_literal: true

# == Ability
#
# @!group 01-Models / Auth
#
# Authorization rules CanCanCan for the platform.
#
# === Roles / Permisos
# * **super_admin** → `:manage` complete control.
# * Profile owner → `:read, :update` over his {Profile}.
# * **academy** or **admin** → `:invite` over {User}.
#
# @example Controller Use
#   authorize! :invite, User
# @example Using role and resource
#   can :manage, Group, id: resource.id if user.has_role_for?(:mentor, resource)
#   can [:manage], Group, id: user.groups.ids if user.has_role?(:mentor)
#
# @!endgroup
#

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    # ─── SUPER ADMIN ─────────────────────────────
    if user.has_role?(:super_admin)
      can :manage, :all
      return
    end

    # ─── ADMIN ───────────────────────────────────
    if user.has_role?(:admin)
      can :invite, User
      can :manage, Topic
      can :manage, ContentTopic
      can :manage, Enrollment
      can :manage, Group
    end

    # ─── ACADEMY ────────────────────────────────
    if user.has_role?(:academy)
      can :invite, User
      can :manage, Enrollment
      can [ :create ], Group
      can [ :update, :read ], Group, created_by: user.id
    end

    # ─── MENTOR ──────────────────────────────────
    if user.has_role?(:mentor)
      can :manage, Group, id: user.assigned_groups.map(&:id)
    end

    # ─── ROLES ───────────────────────────────────
    can :assign_role, User if user.has_role?(:admin) || user.has_role?(:academy) || user.has_role?(:super_admin)
    can :remove_role, User if user.has_role?(:admin) || user.has_role?(:academy) || user.has_role?(:super_admin)

    # ─── PROFILE OWNER ───────────────────────────
    can [ :read, :update ], Profile, user_id: user.id

    # ─── CONTENT UNITS ──────────────────────────

    # ─── TOPICS ──────────────────────────────────
    can [ :read ], Topic, state: "visible"
    can [ :create, :update, :destroy ], Topic, created_by: user.id

    # ─── CONTENT TOPICS ──────────────────────────
    can [ :read ], ContentTopic, state: "visible"
    can [ :create, :update, :destroy ], ContentTopic do |content_topic|
      content_topic.content_unit&.created_by == user.id
    end

    # ─── ENROLLMENT ──────────────────────────────
    can [ :create, :read, :update ], Enrollment, user_id: user.id

    # ─── GROUPS ──────────────────────────────────
    can :read, Group, state: "published"

    # ─── EVALUATION ──────────────────────────────
    can :read, Evaluation, state: "visible"
    if user.has_role?(:admin) || user.has_role?(:academy) || user.has_role?(:mentor)
      can [ :create, :update ], Evaluation, created_by: user.id
    end
  end
end
