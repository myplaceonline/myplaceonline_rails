class Book < MyplaceonlineIdentityRecord
  include ModelHelpersConcern
  include AllowExistingConcern
  
  validates :book_name, presence: true
  
  boolean_time_transfer :is_read, :when_read
  
  belongs_to :recommender, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :recommender, reject_if: :all_blank
  allow_existing :recommender, Contact
  
  def display
    book_name
  end
end
