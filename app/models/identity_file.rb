require "base64"

class IdentityFile < MyplaceonlineIdentityRecord
  include AllowExistingConcern
  
  before_update :do_before_update

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
  
  def do_before_update
    if self.file_file_size_changed?
      # Make sure any thumbnail is cleared (if it's a picture)
      self.thumbnail_contents = nil
      self.thumbnail_bytes = nil
    end
  end
  
  def self.build(params = nil)
    result = super(params)
    if !params[:folder].nil?
      folders = IdentityFileFolder.where(
        owner_id: User.current_user.primary_identity.id,
        id: params[:folder].to_i
      )
      if folders.size > 0
        result.folder = folders.first
      end
    end
    result
  end

  def as_json(options={})
    super.as_json(options).merge({
      "thumbnail_contents" => thumbnail_contents.nil? ? nil : ::Base64.strict_encode64(thumbnail_contents)
    })
  end
end
