class Quote < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :quote_text, presence: true
  
  def display
    Myp.ellipses_if_needed(self.quote_text, 16)
  end
end
