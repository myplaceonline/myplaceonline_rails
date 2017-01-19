class CalculationInput < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :calculation_form
end
