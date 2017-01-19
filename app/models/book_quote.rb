class BookQuote < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :book

  def display
    quote.display
  end

  child_property(name: :quote, required: true)
end
