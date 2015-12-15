class Drink < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :drink_name, presence: true

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
