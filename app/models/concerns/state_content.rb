module StateContent
  extend ActiveSupport::Concern

  includede do
    enum state: CONTENT_STATES
    validates :state, presence: true, inclusion: { in: ->(_) { CONTENT_STATES.keys.map(&:to_s) } }

     scope :draft, -> { where(state: :draft) }
     scope :visible, -> { where(state: :visible) }
     scope :archived, -> { where(state: :archived) }
     scope :hidden, -> { where(state: :hidden) }
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
    state == "hidden"
  end
end
