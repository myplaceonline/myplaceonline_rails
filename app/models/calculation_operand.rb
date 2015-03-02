class CalculationOperand < ActiveRecord::Base
  # Recursive operand
  belongs_to :calculation_element
  accepts_nested_attributes_for :calculation_element, reject_if: :all_blank
  
  # constant_value:string
  
  validate do
    if blank?
      errors.add(:base, I18n.t("myplaceonline.calculation_forms.operand_blank"))
    end
  end
  
  def blank?
    constant_value.blank? && calculation_element.nil?
  end
end
