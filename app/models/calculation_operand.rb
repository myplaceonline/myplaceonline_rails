class CalculationOperand < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  # Recursive operand
  child_property(name: :calculation_element)
  
  child_property(name: :calculation_input)
  
  # constant_value:string
  
  validate do
    if blank?
      errors.add(:base, I18n.t("myplaceonline.calculation_forms.operand_blank"))
    end
  end
  
  def blank?
    constant_value.blank? && calculation_element.nil?
  end
  
  def to_human_readable
    calculation_element.nil? ? constant_value : calculation_element.to_human_readable
  end
end
