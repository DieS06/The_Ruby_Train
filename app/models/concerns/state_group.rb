module StateGroup
  extend ActiveSupport::Concern

  included do
    include Stateable

    define_state_enum({
      open: 0,
      active: 1,
      closed: 2,
      archived: 3
    })
  end
end
