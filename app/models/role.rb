# frozen_string_literal: true

# == Role
#
# @!group 01-Models / Users
#
# Rolify Model that associates {User} with permission, optional
# polymorphic on any resource.
#
# === Attributes
# @!attribute name
#   @return [String] Rol name ("admin", "student", "mentor", etc.).
# @!attribute resource_type
#   @return [String, nil] Polymorphic resource type, if context is needed.
# @!attribute resource_id
#   @return [Integer, nil] Polymorphic resource ID, associated with the role and resource_type.
#
# @example Assign global rol
#   user.add_role(:student)
#
# @example Role with resource context
#   course = Course.first
#   user.add_role(:mentor, course)
#
# @!endgroup
#

class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles

  belongs_to :resource,
             polymorphic: true,
             optional: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  validates :name,
            presence: true,
            uniqueness: { scope: :resource_type },
            length: { maximum: 50 }

  scopify
end
