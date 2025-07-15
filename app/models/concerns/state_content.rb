module StateContent
  extend ActiveSupport::Concern

  included do
    enum :state, {
      draft: 0,
      visible: 1,
      archived: 2,
      deleted: 3
    }

    validates :state, presence: true

     scope :draft, -> { where(state: :draft) }
     scope :visible, -> { where(state: :visible) }
     scope :archived, -> { where(state: :archived) }
     scope :deleted, -> { where(state: :deleted) }
  end

  def draft?
    state == "draft"
  end

  def visible?
    state == "visible"
  end

  def archived?
    state == "archived"
  end

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
