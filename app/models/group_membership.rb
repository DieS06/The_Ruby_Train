# frozen_string_literal: true

# == GroupMembership
#
# @!group 01-Models / Groups
#
# GroupMembership defines the participation of a User in a Group,
# including metadata like role, invitation, and membership state.
#
# === Attributes
# @!attribute [rw] group_id
#   @return [Integer] Foreign key for Group
# @!attribute [rw] user_id
#   @return [Integer] Foreign key for User
# @!attribute [rw] joined_at
#   @return [DateTime] When the user joined the group
# @!attribute [rw] role_in_group
#   @return [Integer] Enum: member, assistant, mentor, coordinator
# @!attribute [rw] invited_by
#   @return [Integer] User ID who sent the invitation
# @!attribute [rw] invited_token
#   @return [String] Token used for joining (if invite-based)
# @!attribute [rw] state
#   @return [Integer] Enum: draft, active, archived
#
# === Associations
# * belongs_to :group
# * belongs_to :user
# * belongs_to :inviter (optional, User)
#
# === Validations
# * Unique [group_id, user_id] pair
# * Presence of role_in_group and state
#
# @!endgroup
#

class GroupMembership < ApplicationRecord
  include StateMembership
  belongs_to :group
  belongs_to :user
  belongs_to :inviter, class_name: "User", foreign_key: :invited_by, optional: false
  before_validation :set_invited_token, if: -> { state == "invited" }

  enum :role_in_group, {
    member: 0,
    assistant: 1,
    mentor: 2,
    coordinator: 3
  }, default: :member, prefix: true

  validates :state, presence: true
  validates :group_id, uniqueness: { scope: :user_id }
  validates :role_in_group, presence: true, inclusion: { in: ->(record) { record.class.role_in_groups.keys } }

  validates :invited_token, length: { maximum: 64 }, allow_blank: true
  validates :invited_token, presence: true, if: -> { state == "invited" }
  validates :invited_by, presence: true, if: -> { state == "invited" }

  before_validation :set_joined_at, if: -> { state == "active" }

  private

  def set_joined_at
    self.joined_at ||= Time.current
  end

  def set_invited_token
    self.invited_token ||= SecureRandom.hex(16)
  end
end
