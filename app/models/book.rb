class Book < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern
  include AllowExistingConcern
  
  validates :book_name, presence: true
  
  boolean_time_transfer :is_read, :when_read
  
  belongs_to :recommender, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :recommender, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :recommender, Contact
  
  has_many :book_quotes, -> { order("pages ASC, updated_at DESC") }, :dependent => :destroy
  accepts_nested_attributes_for :book_quotes, allow_destroy: true, reject_if: :all_blank
  
  def display
    Myp.appendstrwrap(book_name, author)
  end
end
