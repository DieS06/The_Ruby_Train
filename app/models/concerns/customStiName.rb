module CustomStiName
  extend ActiveSupport::Concern

  class_methods do
    def sti_name
      name.demodulize.sub(/Unit$/, "")
    end
  end
end
