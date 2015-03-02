class CalculationElement < ActiveRecord::Base
  belongs_to :left_operand, class_name: CalculationOperand, autosave: true
  validates_associated :left_operand
  validates_presence_of :left_operand
  accepts_nested_attributes_for :left_operand
  
  belongs_to :right_operand, class_name: CalculationOperand, autosave: true
  validates_associated :right_operand
  validates_presence_of :right_operand
  accepts_nested_attributes_for :right_operand
  
  # t.integer  "operator"
  
  def self.build
    new_element = CalculationElement.new
    new_element.left_operand = CalculationOperand.new
    new_element.right_operand = CalculationOperand.new
    new_element
  end
end
