class RoleSerializer < ActiveModel::Serializer
  attributes :id, :name, :resource_type, :resource_id
end
