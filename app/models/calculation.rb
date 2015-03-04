class Calculation < ActiveRecord::Base
  belongs_to :calculation_form
  belongs_to :identity
  validates :name, presence: true
end
