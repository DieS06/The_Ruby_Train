# app/lib/states/user_states.rb
module States
  class UserStates
    PENDING   = "pending"
    INACTIVE  = "inactive"
    ACTIVE    = "active"
    SUSPENDED = "suspended"

    VALUES = [ PENDING, INACTIVE, ACTIVE, SUSPENDED ].freeze

    HUMANIZED = {
      PENDING   => "Pending",
      INACTIVE  => "Inactive",
      ACTIVE    => "Active",
      SUSPENDED => "Suspended"
    }.freeze

    def self.valid?(value)
      VALUES.include?(value)
    end

    def self.all
      VALUES
    end

    def self.options_for_select
      VALUES.map { |val| [ HUMANIZED[val], val ] }
    end

    def self.label(state)
      HUMANIZED[state.to_s] || state.to_s.titleize
    end
  end
end
