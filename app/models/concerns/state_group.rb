module StateGroup
  extend ActiveSupport::Concern

  included do
    enum :state, {
      open: 0,
      active: 1,
      closed: 2,
      archived: 3
    }

    validates :state, presence: true

    scope :open, -> { where(state: :open) }
    scope :active, -> { where(state: :active) }
    scope :closed, -> { where(state: :closed) }
    scope :archived, -> { where(state: :open) }
  end

  def open?
    state == "open"
  end

  def active?
    state == "active"
  end

  def closed?
    state == "closed"
  end

  def archived?
    state == "archived"
  end
end
