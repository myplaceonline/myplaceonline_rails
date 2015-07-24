class VehicleWarranty < ActiveRecord::Base
  belongs_to :owner, class_name: Identity
  belongs_to :vehicle

  belongs_to :warranty
  accepts_nested_attributes_for :warranty, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def warranty_attributes=(attributes)
    if !attributes['id'].blank?
      self.warranty = Warranty.find(attributes['id'])
    end
    super
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
