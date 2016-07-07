class PasswordShare < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :password, presence: true
  validates :user, presence: true

  belongs_to :password
  accepts_nested_attributes_for :password
  allow_existing :password

  belongs_to :user
  accepts_nested_attributes_for :user
  allow_existing :user
  
  has_many :password_secret_shares, :dependent => :destroy
  accepts_nested_attributes_for :password_secret_shares, allow_destroy: true, reject_if: :all_blank

  def display
    password.display + ":" + user.display
  end
  
  def permission_action(action)
    action == :transfer ? Permission::ACTION_READ : Permission::ACTION_UPDATE
  end
end
