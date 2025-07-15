module StateMembership
  extend ActiveSupport::Concern

  included do
    enum :state, {
      pending: 0,
      invited: 1,
      joined: 2,
      rejected: 3,
      removed: 4
    }

    validates :state, presence: true

    scope :pending, -> { where(state: :pending) }
    scope :invited, -> { where(state: :invited) }
    scope :joined, -> { where(state: :joined) }
    scope :rejected, -> { where(state: :rejected) }
    scope :removed, -> { where(state: :removed) }
  end

  def pending?
    state == "pending"
  end

  def invited?
    state == "invited"
  end

  def joined?
    state == "joined"
  end

  def rejected?
    state == "rejected"
  end

  def removed?
    state == "removed"
  end
end
