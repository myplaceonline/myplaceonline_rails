class DesiredProduct < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :product_name, presence: true
  
  def display
    product_name
  end
end
