class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :manage, :all if user.has_role?(:super_admin)
    can [:read, :update], Profile, user_id: user.id
    can :invite, User if user.has_role?(:academy) || user.has_role?(:admin)
    # can [:manage], Group, id: user.groups.ids if user.has_role?(:mentor)

  end
end

# To use role and resource 
# can :manage, Group, id: resource.id if user.has_role_for?(:mentor, resource)

# At controller to add autorization for invitations
# authorize! :invite, User