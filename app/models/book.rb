class Book < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern
  include AllowExistingConcern
  
  validates :book_name, presence: true
  myplaceonline_validates_uniqueness_of :book_name
  
  boolean_time_transfer :is_read, :when_read
  
  child_property(name: :recommender, model: Contact)
  
  child_property(name: :lent_to, model: Contact)
  
  child_property(name: :borrowed_from, model: Contact)
  
  child_properties(name: :book_quotes, sort: "pages ASC, updated_at DESC")
  
  child_files

  def display
    Myp.appendstrwrap(book_name, author)
  end

  def self.skip_check_attributes
    ["is_read"]
  end
end
