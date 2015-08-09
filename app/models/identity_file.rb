class IdentityFile < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
  belongs_to :encrypted_password, class_name: EncryptedValue, dependent: :destroy

  has_attached_file :file, :storage => :database
  do_not_validate_attachment_file_type :file
  
  belongs_to :folder, class_name: IdentityFileFolder
  accepts_nested_attributes_for :folder
  allow_existing :folder, IdentityFileFolder

  def display
    file_file_name
  end

  def get_password(session)
    if !encrypted_password.nil?
      Myp.decrypt_from_session(session, encrypted_password)
    else
      nil
    end
  end
  
  def size
    file_file_size
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
