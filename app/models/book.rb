class Book < ActiveRecord::Base
  belongs_to :owner, class_name: Identity
  validates :book_name, presence: true
  attr_accessor :is_read
  
  def display
    book_name
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
