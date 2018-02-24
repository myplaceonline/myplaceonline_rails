class PaidTax < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :fiscal_year, presence: true
  
  def display
    "#{fiscal_year}"
  end

  child_files

  child_property(name: :password)
end
