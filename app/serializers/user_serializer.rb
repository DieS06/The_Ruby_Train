class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email,
             :phone_number, :full_name, :state
  has_one :profile, serializer: ProfileSerializer
  has_many :roles, serializer: RoleSerializer

  def full_name
    object.full_name
  end

  def state_label
    States::UserState.label(object.state)
  end

  def account_date
    object.created_at.strftime("%B %d, %Y")
  end
end
