require "base64"

# TODO
# https://github.com/willbryant/columns_on_demand
# https://github.com/jorgemanrubia/lazy_columns
class IdentityFile < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  SIZE_THRESHOLD_FILESYSTEM = 1048576 * 10

  before_create :do_before_create
  before_update :do_before_update

  belongs_to :encrypted_password, class_name: EncryptedValue, dependent: :destroy

  has_attached_file :file, :storage => :database
  do_not_validate_attachment_file_type :file
  
  # Unclear why but validations don't get called
  #validate do
  #  if file.nil? || get_file_contents.nil? || get_file_contents.length == 0
  #    errors.add(:file, I18n.t("myplaceonline.general.non_blank"))
  #  end
  #end
  
  belongs_to :folder, class_name: IdentityFileFolder
  accepts_nested_attributes_for :folder
  allow_existing :folder, IdentityFileFolder

  has_many :identity_file_shares

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
  
  def do_before_create
    if file_file_name.blank? && !file.nil?
      if !file.queued_for_write.nil? && file.queued_for_write[:original]
        self.file_file_name = file.queued_for_write[:original].original_filename
      end
    end
  end
  
  def do_before_update
    if self.file_file_size_changed?
      # Make sure any thumbnail is cleared (if it's a picture)
      clear_thumbnail
    end
  end
  
  def clear_thumbnail
    self.thumbnail_contents = nil
    self.thumbnail_bytes = nil
    self.thumbnail_skip = nil
    self.thumbnail_hash = nil
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    if !params.nil? && !params[:folder].nil?
      folders = IdentityFileFolder.where(
        identity_id: User.current_user.primary_identity.id,
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
  
  def file_extension
    i = file_file_name.index(".")
    if !i.nil?
      file_file_name[i..-1]
    else
      nil
    end
  end
  
  def get_file_contents
    Rails.logger.info{"get_file_contents: Request for full image contents id #{self.id}"}
    result = nil
    if !self.file.nil?
      #puts caller
      #FileProxy.where(identity_file_id: self.id).first.file_contents
      result = file.file_contents
    end
    Rails.logger.info{"get_file_contents: Returning #{ result.nil? ? 0 : result.length }"}
    result
  end
end
