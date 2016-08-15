class Connection < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  STATUS_PENDING = 1

  belongs_to :user
  accepts_nested_attributes_for :user, reject_if: :all_blank
  allow_existing :user

  validates :user, presence: true

  def display
    user.display
  end
  
  validate do
    if self.connection_status.nil?
      self.connection_status = Connection::STATUS_PENDING
    end
    if !user.nil? && user.id == User.current_user.id
      errors.add(:user, I18n.t("myplaceonline.connections.friends_self"))
    end
  end
end
