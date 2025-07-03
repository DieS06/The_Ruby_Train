# frozen_string_literal: true

# == RoleSerializer
#
# Serialize {Role} for {User}.
#
# === JSON Attributes
# * id, name, resource_type, resource_id
#

class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :resource_type, :resource_id
end
