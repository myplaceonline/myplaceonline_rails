class EnteredInviteCode < ApplicationRecord
  include MyplaceonlineActiveRecordBaseConcern
  
  belongs_to :user
  belongs_to :website_domain

  attr_accessor :code
  
  before_create :set_info
  
  def display
    self.website_domain.display
  end
  
  def set_info
    
    self.user = User.current_user
    self.website_domain = Myp.website_domain
    
    true
  end
  
  validate :check_code
  
  def check_code
    if Myp.requires_invite_code && !InviteCode.valid_code?(self.code)
      errors.add(:code, I18n.t("myplaceonline.entered_invite_codes.not_valid"))
    end
  end
end
