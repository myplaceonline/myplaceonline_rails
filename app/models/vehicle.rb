class Vehicle < ActiveRecord::Base
  belongs_to :identity
  validates :name, presence: true

  has_many :vehicle_loans, :dependent => :destroy
  accepts_nested_attributes_for :vehicle_loans, allow_destroy: true, reject_if: :all_blank

  has_many :vehicle_services, :dependent => :destroy
  accepts_nested_attributes_for :vehicle_services, allow_destroy: true, reject_if: :all_blank
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
