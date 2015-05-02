class Vitamin < ActiveRecord::Base
  belongs_to :identity
  
  validates :vitamin_name, presence: true

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
  
  def display
    vitamin_name
  end
  
  def self.params
    [
      :id,
      :vitamin_name,
      :notes,
      :amount_type,
      :vitamin_amount
    ]
  end
end
