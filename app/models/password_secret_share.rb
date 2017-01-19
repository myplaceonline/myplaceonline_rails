class PasswordSecretShare < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :password_secret
  
  validates :password_secret, presence: true

  def display
    password_share.display
  end
end
