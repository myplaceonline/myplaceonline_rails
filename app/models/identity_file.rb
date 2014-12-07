class IdentityFile < ActiveRecord::Base
  belongs_to :identity
  belongs_to :encrypted_password, class_name: EncryptedValue, dependent: :destroy

  has_attached_file :file, :path => ":rails_root/storage/:rails_env/attachments/:id/:style/:basename.:extension"
  do_not_validate_attachment_file_type :file

  def getPassword(session)
    Myp.decrypt_from_session(session, encrypted_password)
  end
end
