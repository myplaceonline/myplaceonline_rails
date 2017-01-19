class CalculationElement < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates_associated :left_operand
  child_property(name: :left_operand, model: CalculationOperand, required: true)
  
  validates_associated :right_operand
  child_property(name: :right_operand, model: CalculationOperand, required: true)
  
  # t.integer  "operator"
  
  def self.build(params = nil)
    new_element = self.dobuild(params)
    new_element.left_operand = CalculationOperand.new
    new_element.right_operand = CalculationOperand.new
    new_element
  end
  
  def to_human_readable
    "(" + left_operand.to_human_readable + " " + CalculationElement.operator_display_map[operator] + " " + right_operand.to_human_readable + ")"
  end
  
  def self.operator_map
    {
      "+ (Add)" => 1,
      "- (Subtract)" => 2,
      "* (Multiply)" => 3,
      "/ (Divide)" => 4
    }
  end
  
  def self.operator_display_map
    {
      1 => "+",
      2 => "-",
      3 => "*",
      4 => "/"
    }
  end
  
  def all_operands
    resultSet = Set.new
    process_operand(resultSet, left_operand)
    process_operand(resultSet, right_operand)
    resultSet.to_a
  end
  
  def process_operand(resultSet, operand)
    resultSet.add(operand)
    if !operand.calculation_element.nil?
      process_operand(resultSet, operand.calculation_element.left_operand)
      process_operand(resultSet, operand.calculation_element.right_operand)
    end
  end
end
