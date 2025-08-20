# frozen_string_literal: true

# == InviteUserService
#
# @!group Services / Users
#
# Service that sends invitations to the platform or a group, using Devise-Invitable.
# It assigns roles (global or scoped), creates profiles, and initializes memberships if needed.
#
# === Parameters
# @param inviter [User] User who sends the invitation
# @param email [String] Email of the user to invite
# @param first_name [String] First name of the user
# @param last_name [String] Last name of the user
# @param message [String] Optional custom message
# @param role [String, Symbol] Optional role to assign (global or group)
# @param group [Group, nil] Optional group to assign user to
#
# === Returns
# @return [User] The invited or found user
#
# === Example
#   InviteUserService.call(
#     inviter: current_user,
#     email: "new@user.com",
#     first_name: "New",
#     last_name: "User",
#     role: :student,
#     group: @group
#   )
#
# @!endgroup
#

class InviteUserService
  def self.call(inviter:, email:, first_name:, last_name:, message: nil, role: nil, group: nil)
    raise CanCan::AccessDenied unless Ability.new(inviter).can?(:invite, User)

    user = User.find_by(email:) || User.invite!(email:, first_name:, last_name:)
    user.create_profile unless user.profile
    user.add_role(role) if role.present? && !group && !user.has_role?(role)

    if group.present?
      user.add_role(role, group) if role.present? && !user.has_role?(role, group)

      token = Devise.friendly_token(32)

      GroupMembership.create_with(
        invited_by: inviter.id,
        invited_token: token,
        state: :invited
      ).find_or_create_by!(group:, user:)
    end

    InvitationMailer.custom_invite(user, inviter, message, group: group).deliver_later

    Rails.logger.info "#{inviter.full_name} invited #{user.email} #{group ? "to #{group.name}" : ""}"
    user
  end
end
