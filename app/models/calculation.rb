class Calculation < ActiveRecord::Base
  belongs_to :identity
  validates :name, presence: true
  
  belongs_to :calculation_form, dependent: :destroy, :autosave => true
  accepts_nested_attributes_for :calculation_form
  validates_presence_of :calculation_form

  attr_accessor :original_calculation_form_id

  validate do
    if !calculation_form.nil?
      calc = create_cal
      dependencies = calc.dependencies(calculation_form.equation)
      dependencies.each do |dependency|
        missing_input = calculation_form.calculation_inputs.find{|calculation_input| calculation_input.variable_name == dependency.to_s }
        if !missing_input.nil?
          errors.add(:answer, I18n.t("myplaceonline.calculations.input_missing", input_name: missing_input.input_name))
        end
      end
    end
  end
  
  def create_cal
    calc = Dentaku::Calculator.new
    calculation_form.calculation_inputs.each do |calculation_input|
      if !calculation_input.input_value.blank?
        calc.store(calculation_input.variable_name => calculation_input.input_value.to_f)
      end
    end
    calc
  end
  
  def evaluate
    create_cal.evaluate(calculation_form.equation).to_s
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
