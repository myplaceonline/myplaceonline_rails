class VehicleLoan < ActiveRecord::Base
  belongs_to :vehicle

  belongs_to :owner, class_name: Identity
  
  belongs_to :loan, :dependent => :destroy
  accepts_nested_attributes_for :loan, allow_destroy: true, reject_if: :all_blank
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
