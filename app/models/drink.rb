class Drink < ActiveRecord::Base
  belongs_to :identity
  
  validates :drink_name, presence: true

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
  
  def display
    drink_name
  end
  
  def self.params
    [
      :id,
      :drink_name,
      :notes,
      :calories,
      :price
    ]
  end
end
