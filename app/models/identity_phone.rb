class IdentityPhone < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  PHONE_TYPES = [
    ["myplaceonline.identity_phones.cell", 0],
    ["myplaceonline.identity_phones.home", 1],
    ["myplaceonline.identity_phones.work", 3],
    ["myplaceonline.identity_phones.temporary", 2]
  ]
  
  belongs_to :parent_identity, class_name: Identity
  
  def context_info
    case phone_type
    when 0
      I18n.t("myplaceonline.identity_phones.cell")
    when 1
      I18n.t("myplaceonline.identity_phones.home")
    when 2
      I18n.t("myplaceonline.identity_phones.temporary")
    when 3
      I18n.t("myplaceonline.identity_phones.work")
    else
      I18n.t("myplaceonline.identity_phones.phone")
    end
  end
  
  def accepts_sms?
    phone_type.nil? || phone_type == 0
  end
end
