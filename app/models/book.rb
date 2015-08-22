class Book < MyplaceonlineActiveRecord
  validates :book_name, presence: true
  attr_accessor :is_read
  
  def display
    book_name
  end
end
