class BookQuote < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :book

  validates :book_quote, presence: true
  
  def display
    book_quote
  end
end
