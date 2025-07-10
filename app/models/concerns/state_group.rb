module StateGroup
  extend ActiveSupport::Concern

  includede do
    enum state: GROUP_STATES

    validates :state, presence: true, inclusion: { in: ->(_) { GROUP_STATES.keys.map(&:to_s) } }

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
