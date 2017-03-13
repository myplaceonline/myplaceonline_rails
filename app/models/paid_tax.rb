class PaidTax < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :paid_tax_date, presence: true
  validates :paid_tax_description, presence: true
  
  def display
    paid_tax_description
  end

  child_files

  child_property(name: :password)
end
