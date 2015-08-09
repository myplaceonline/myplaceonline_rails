class TherapistLocation < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
  belongs_to :therapist

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: :all_blank
  allow_existing :location
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
