module StateCU
  extend ActiveSupport::Concern

  includede do
    enum state: SHARED_STATES
    validates :state, presence: true, inclusion: { in: ->(_) { SHARED_STATES.keys.map(&:to_s) } }
  end
end
