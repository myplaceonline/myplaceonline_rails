class SshKey < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :ssh_key_name, presence: true
  validates :ssh_private_key, presence: true
  validates :ssh_public_key, presence: true
  
  def display
    ssh_key_name
  end
  
  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :password
end
