module StateMembership
  extend ActiveSupport::Concern

  included do
    include Stateable

    define_state_enum({
      pending: 0,
      invited: 1,
      joined: 2,
      rejected: 3,
      removed: 4
    })
  end
end
