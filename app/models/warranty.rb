class Warranty < ActiveRecord::Base
  belongs_to :owner, class_name: Identity
  
  validates :warranty_name, presence: true
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
  
  def display
    warranty_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :warranty_name,
      :warranty_start,
      :warranty_end,
      :warranty_condition,
      :notes
    ]
  end
end
