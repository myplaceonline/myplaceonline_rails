class CalculationInput < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :calculation_form
end
