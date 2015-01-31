class IdentityFile < ActiveRecord::Base
  belongs_to :identity
  belongs_to :encrypted_password, class_name: EncryptedValue, dependent: :destroy

  has_attached_file :file, :storage => :database
  do_not_validate_attachment_file_type :file

  def get_password(session)
    if !encrypted_password.nil?
      Myp.decrypt_from_session(session, encrypted_password)
    else
      nil
    end
  end
end
