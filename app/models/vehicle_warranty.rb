class VehicleWarranty < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
  belongs_to :vehicle

  belongs_to :warranty
  accepts_nested_attributes_for :warranty, allow_destroy: true, reject_if: :all_blank
  allow_existing :warranty
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
