class Book < MyplaceonlineIdentityRecord
  include ModelHelpersConcern
  
  validates :book_name, presence: true
  
  boolean_time_transfer :is_read, :when_read
  
  def display
    book_name
  end
end
