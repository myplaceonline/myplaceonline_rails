class IdentityPhone < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  
  PHONE_TYPE_CELL = 0
  PHONE_TYPE_HOME = 1
  PHONE_TYPE_TEMPORARY = 2
  PHONE_TYPE_WORK = 3

  PHONE_TYPES = [
    ["myplaceonline.identity_phones.cell", PHONE_TYPE_CELL],
    ["myplaceonline.identity_phones.home", PHONE_TYPE_HOME],
    ["myplaceonline.identity_phones.work", PHONE_TYPE_WORK],
    ["myplaceonline.identity_phones.temporary", PHONE_TYPE_TEMPORARY]
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

  def final_search_result
    parent_identity.contact
  end
  
  def show_highly_visited?
    false
  end
end
