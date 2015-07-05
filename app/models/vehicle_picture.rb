class VehiclePicture < ActiveRecord::Base
  belongs_to :vehicle
  belongs_to :owner, class: Identity

  belongs_to :identity_file
  accepts_nested_attributes_for :identity_file, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def identity_file_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.identity_file = IdentityFile.find(attributes['id'])
    end
    super
  end

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
