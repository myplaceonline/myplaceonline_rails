require "base64"

# TODO
# https://github.com/willbryant/columns_on_demand
# https://github.com/jorgemanrubia/lazy_columns
class IdentityFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  def self.properties
    [
      { name: :file, type: ApplicationRecord::PROPERTY_TYPE_FILE },
      { name: :file_file_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :folder, type: ApplicationRecord::PROPERTY_TYPE_CHILD, model: IdentityFileFolder },
      { name: :_updatetype, type: ApplicationRecord::PROPERTY_TYPE_HIDDEN },
    ]
  end
  
  SIZE_THRESHOLD_FILESYSTEM = 1048576 * 10

  before_create :do_before_create
  before_update :do_before_update

  belongs_to :encrypted_password, class_name: "EncryptedValue"

  has_attached_file :file, :storage => :database
  do_not_validate_attachment_file_type :file
  
  # Unclear why but validations don't get called
  #validate do
  #  if file.nil? || get_file_contents.nil? || get_file_contents.length == 0
  #    errors.add(:file, I18n.t("myplaceonline.general.non_blank"))
  #  end
  #end
  
  child_property(name: :folder, model: IdentityFileFolder)

  has_many :identity_file_shares

  def display
    file_file_name
  end
  
  def urlname
    file_file_name
  end

  def get_password(session)
    if !encrypted_password.nil?
      Myp.decrypt_with_user_password!(encrypted_password)
    else
      nil
    end
  end
  
  def size
    file_file_size
  end
  
  def do_before_create
    Rails.logger.debug{"IdentityFile do_before_create"}
    if file_file_name.blank? && !file.nil?
      if !file.queued_for_write.nil? && file.queued_for_write[:original]
        self.file_file_name = file.queued_for_write[:original].original_filename
      end
    end
  end
  
  def do_before_update
    file_sized_changed = self.file_file_size_changed?
    Rails.logger.debug{"IdentityFile do_before_update; file_sized_changed: #{file_sized_changed}"}
    if file_sized_changed
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
        identity_id: User.current_user.current_identity_id,
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
      result = self.file.file_contents
    end
    Rails.logger.info{"get_file_contents: Returning #{ result.nil? ? 0 : result.length }"}
    result
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    ensure_thumbnail
  end

  def is_image?
    !self.file.nil? && !self.file_content_type.blank? && self.file_content_type.start_with?("image")
  end

  def is_thumbnailable?
    self.file_content_type.index("x-xcf").nil?
  end
  
  def is_audio?
    !self.file.nil? && !self.file_content_type.blank? && self.file_content_type.start_with?("audio")
  end
  
  def is_video?
    !self.file.nil? && !self.file_content_type.blank? && self.file_content_type.start_with?("video")
  end
  
  def has_thumbnail?
    !self.thumbnail_skip && !self.thumbnail_contents.nil?
  end

  def ensure_thumbnail
    Rails.logger.debug{"IdentityFile ensure_thumbnail"}
    if is_image? && self.thumbnail_contents.nil? && !self.thumbnail_skip && is_thumbnailable?
      Rails.logger.debug{"image_content: Generating thumbnail for #{self.id}, type #{self.file_content_type}"}
      image = Magick::Image::from_blob(self.get_file_contents)
      Rails.logger.debug{"image_content: Loaded image"}
      image = image.first
      Rails.logger.debug{"image_content: Acquired first image cols #{image.columns}"}
      max_width = 400
      if image.columns > max_width
        Rails.logger.debug{"image_content: Requires thumbnailing"}
        image.resize_to_fit!(max_width)
        blob = image.to_blob
        self.thumbnail_contents = blob
        self.thumbnail_bytes = blob.length
        self.thumbnail_hash = Digest::MD5.hexdigest(blob)
        self.save!
        Rails.logger.debug{"image_content: Saved thumbnail"}
      else
        Rails.logger.debug{"image_content: Thumbnail not required"}
        self.thumbnail_skip = true
        self.save!
      end
    end
    
    if has_thumbnail? && thumbnail_hash.nil?
      Rails.logger.debug{"image_content: Updating hash for already generated thumbnail"}
      self.thumbnail_hash = Digest::MD5.hexdigest(self.thumbnail_contents)
      self.save!
    end
  end
end
