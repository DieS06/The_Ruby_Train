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

    can :manage, :all if user.has_role?(:super_admin)
    can [ :read, :update ], Profile, user_id: user.id
    can :invite, User if user.has_role?(:academy) || user.has_role?(:admin)

    # Evaluation permissions
    can [ :read ], Evaluation, state: "visible"
    can [ :create, :update ], Evaluation, created_by: user.id if user.has_role?(:super_admin) || user.has_role?(:admin) || user.has_role?(:academy) || user.has_role?(:mentor)
  end
end
