module MyplaceonlineSimpleModelConcern
  extend ActiveSupport::Concern

  included do
    def is_public
      false
    end
  end
end
