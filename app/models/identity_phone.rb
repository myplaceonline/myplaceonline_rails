class IdentityPhone < ActiveRecord::Base
  PHONE_TYPES = [
    ["myplaceonline.identity_phones.cell", 0],
    ["myplaceonline.identity_phones.home", 1],
    ["myplaceonline.identity_phones.temporary", 2]
  ]
  
  belongs_to :owner, class_name: Identity
  belongs_to :identity, class_name: Identity
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
