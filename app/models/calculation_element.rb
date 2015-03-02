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
  
  def to_human_readable
    left_operand.to_human_readable + " " + CalculationElement.operator_display_map[operator] + " " + right_operand.to_human_readable
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
end
