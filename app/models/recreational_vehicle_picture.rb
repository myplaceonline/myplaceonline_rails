class RecreationalVehiclePicture < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :recreational_vehicle
  belongs_to :owner, class_name: Identity

  belongs_to :identity_file
  accepts_nested_attributes_for :identity_file, reject_if: :all_blank
  allow_existing :identity_file

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
