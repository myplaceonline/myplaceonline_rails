class Calculation < ActiveRecord::Base
  belongs_to :calculation_form
  belongs_to :identity
  validates :name, presence: true
  validates_presence_of :calculation_form
end
