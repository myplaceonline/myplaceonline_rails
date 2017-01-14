class BookQuote < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :book

  def display
    quote.display
  end

  validates :quote, presence: true
  
  belongs_to :quote
  accepts_nested_attributes_for :quote, allow_destroy: true, reject_if: :all_blank
  allow_existing :quote
end
