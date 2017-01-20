class LifeInsurance < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  LIFE_INSURANCE_TYPES = [
    ["myplaceonline.life_insurances.type_whole", 0],
    ["myplaceonline.life_insurances.type_term", 1]
  ]

  validates :insurance_name, presence: true
  validates :insurance_amount, presence: true
  
  def display
    result = insurance_name
    if !insurance_amount.blank?
      result += " (" + Myp.display_currency(insurance_amount, User.current_user) + ")"
    end
    result
  end
  
  child_property(name: :company)

  child_property(name: :periodic_payment)
  
  child_files
end
