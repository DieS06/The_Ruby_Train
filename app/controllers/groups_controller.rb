# frozen_string_literal: true

# == GroupInvitationsController
#
# @!group Controllers / Groups
#
# Handles acceptance of group invitations via tokenized URLs.
#
# === Endpoints
# * GET /group_invitations/accept/:token  → Accept and join group
#
# @!endgroup
class GroupsController < ApplicationController
  before_action :find_membership_by_token

  def accept
    if @membership.nil?
      render json: { error: "Invalid invitation token" }, status: :not_found
    elsif @membership.joined?
      render json: { message: "Already joined" }, status: :ok
    else
      @membership.update!(
        state: :joined,
        joined_at: Time.current,
        invited_token: nil
      )
      render json: {
        message: "Welcome to the group!",
        group: @membership.group.name,
        user: @membership.user.email
      }, status: :ok
    end
  end

  private

  def find_membership_by_token
    @membership = GroupMembership.find_by(invited_token: params[:token])
  end
end
