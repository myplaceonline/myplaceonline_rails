class CalculationForm < ActiveRecord::Base
  belongs_to :identity
  
  validates :name, presence: true
  
  has_many :calculation_inputs, :dependent => :destroy
  accepts_nested_attributes_for :calculation_inputs, allow_destroy: true, reject_if: :all_blank
  
  belongs_to :root_element, class_name: CalculationElement, autosave: true
  validates_associated :root_element
  validates_presence_of :root_element
  accepts_nested_attributes_for :root_element
end
