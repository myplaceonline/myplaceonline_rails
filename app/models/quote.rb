class Quote < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :quote_text, presence: true
  
  def display
    Myp.ellipses_if_needed(self.quote_text, 64)
  end

  def self.params
    [
      :id,
      :_destroy,
      :quote_text,
      :quote_date,
      :source
    ]
  end
end
