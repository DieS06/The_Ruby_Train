module StateMembership
  extend ActiveSupport::Concern

  included do
    enum state: GROUP_MEMBERSHIP_STATES

    validates :state, presence: true, inclusion: { in: ->(_) { GROUP_MEMBERSHIP_STATES.keys.map(&:to_s) } }

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
