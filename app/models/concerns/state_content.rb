module StateContent
  extend ActiveSupport::Concern
  
  included do
    include Stateable
    
    define_state_enum({
      draft: 0,
      visible: 1,
      archived: 2,
      deleted: 3
    })
  end

  # Custom method not covered by Stateable (renamed for clarity)
  def hidden?
    state == "deleted"
  end

  def visible_for?(user)
    return true if visible?
    return creator?(user) if draft? || archived?
    false
  end

  def creator?(user)
    created_by == user.id
  end
end
