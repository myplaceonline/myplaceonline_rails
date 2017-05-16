class SshKey < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include EncryptedConcern

  validates :ssh_key_name, presence: true
  validates :ssh_private_key, presence: true
  validates :ssh_public_key, presence: true
  
  belongs_to :ssh_private_key_encrypted, class_name: "EncryptedValue", dependent: :destroy, :autosave => true
  belongs_to_encrypted :ssh_private_key
  before_validation :ssh_private_key_finalize
  
  def display
    ssh_key_name
  end
  
  validate do
    if ssh_private_key.blank? && ssh_private_key_encrypted.nil?
      errors.add(:ssh_private_key, t("myplaceonline.general.non_blank"))
    end
  end
  
  child_property(name: :password)

  def as_json(options={})
    if ssh_private_key_encrypted?
      options[:except] ||= %w(ssh_private_key)
    end
    super.as_json(options)
  end

  def self.skip_check_attributes
    ["encrypt"]
  end
end
