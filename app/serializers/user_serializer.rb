# frozen_string_literal: true

# == UserSerializer
#
# Serialize {User} for REST response (login, register).
#
# === JSON Attributes
# * id, first_name, last_name, email, phone_number
# * full_name – helper
# * state & state_label
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email,
             :phone_number, :full_name, :state
  has_one :profile, serializer: ProfileSerializer
  has_many :roles, serializer: RoleSerializer

  def full_name
    object.full_name
  end
end
