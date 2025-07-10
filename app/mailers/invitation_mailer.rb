# frozen_string_literal: true

# == InvitationMailer#custom_invite
#
# @!group Mailers
#
# @!method custom_invite(user, inviter, message, group: nil)
#
# Sends a customized invitation email to the user.
#
# === Parameters
# @param user [User] The user being invited
# @param inviter [User] The user who sends the invitation
# @param message [String] Optional message to include in the email
# @param group [Group, nil] Optional group the user is being invited to
#
# === Behavior
# If a group is passed, includes a special link to accept the group membership.
# Otherwise, sends a standard Devise invitation link.
#
# === Example
#   InvitationMailer.custom_invite(@user, current_user, "Welcome!", group: @group).deliver_later
#
# @!endgroup
#

class InvitationMailer < ApplicationMailer
    def custom_invite(user, inviter, message, group: nil)
        @user = user
        @inviter = inviter
        @message = message.presence || t("We invite you to join our learning community!")
        @group = group
        @url = group.present? ? accept_group_invitation_url(token: user.group_memberships.find_by(group: group)&.invited_token) : accept_user_invitation_url(invitation_token: user.raw_invitation_token)

        mail(
                to: @user.email,
                subject: group ?  t("invitations.group.subject", group: group.name) : t("invitations.platform.subject")
            ) do |format|
                format.text { render layout: "mailer" }
                format.html { render layout: "mailer" }
        end.deliver_later(queue: :mailers)
    end
end
