class IdentityFile < ActiveRecord::Base
  belongs_to :owner, class: Identity
  belongs_to :encrypted_password, class_name: EncryptedValue, dependent: :destroy

  has_attached_file :file, :storage => :database
  do_not_validate_attachment_file_type :file
  
  belongs_to :folder, class_name: IdentityFileFolder
  accepts_nested_attributes_for :folder

  # http://stackoverflow.com/a/12064875/4135310
  def folder_attributes=(attributes)
    if !attributes['id'].blank?
      self.folder = IdentityFileFolder.find(attributes['id'])
    end
    super
  end

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
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
