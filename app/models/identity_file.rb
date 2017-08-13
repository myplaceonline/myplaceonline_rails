require "base64"
require "open3"

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

  # Unclear why but in some situations validations don't get called, so use do_before* instead
  #validate do
  #  if file.nil? || get_file_contents.nil? || get_file_contents.length == 0
  #    errors.add(:file, I18n.t("myplaceonline.general.non_blank"))
  #  end
  #end
  
  before_create :do_before_create
  before_update :do_before_update

  belongs_to :encrypted_password, class_name: "EncryptedValue"

  has_attached_file :file, :storage => :database
  do_not_validate_attachment_file_type :file
  
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
  
  def verify_file
    Rails.logger.debug{"IdentityFile verify_file"}
    if !ENV["PERMDIR"].blank? && !self.filesystem_path.blank? && !File.absolute_path(self.filesystem_path).start_with?(ENV["PERMDIR"])
      raise "Path #{File.absolute_path(self.filesystem_path)} must start with #{ENV["PERMDIR"]}"
    end
  end
  
  def do_before_create
    Rails.logger.debug{"IdentityFile do_before_create"}
    verify_file
    if file_file_name.blank? && !file.nil?
      if !file.queued_for_write.nil? && file.queued_for_write[:original]
        self.file_file_name = file.queued_for_write[:original].original_filename
      end
    end
  end
  
  def do_before_update
    file_sized_changed = self.file_file_size_changed?
    Rails.logger.debug{"IdentityFile do_before_update; file_sized_changed: #{file_sized_changed}"}
    verify_file
    if file_sized_changed
      # Make sure any thumbnail is cleared (if it's a picture)
      clear_thumbnail
    end
  end
  
  def clear_thumbnail
    self.thumbnail_contents = nil
    self.thumbnail_size_bytes = nil
    self.thumbnail_skip = nil
    
    if !self.thumbnail_filesystem_path.blank?
      File.delete(self.thumbnail_filesystem_path)
    end
    
    self.thumbnail_filesystem_path = nil
    self.thumbnail_filesystem_size = nil
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
    if self.has_file?
      if self.filesystem_path.blank?
        result = self.file.file_contents
      else
        IO.binread(self.filesystem_path)
      end
    end
    Rails.logger.info{"get_file_contents: Returning #{ result.nil? ? 0 : result.length }"}
    result
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    ensure_thumbnail
  end
  
  def has_file?
    (!self.file.nil? && self.file.exists?) || !self.filesystem_path.blank?
  end

  def is_image?
    self.has_file? && !self.file_content_type.blank? && self.file_content_type.start_with?("image")
  end

  def is_thumbnailable?
    self.file_content_type.index("x-xcf").nil?
  end
  
  def is_audio?
    self.has_file? && !self.file_content_type.blank? && self.file_content_type.start_with?("audio")
  end
  
  def is_video?
    self.has_file? && !self.file_content_type.blank? && self.file_content_type.start_with?("video")
  end
  
  def has_thumbnail?
    !self.thumbnail_skip && (!self.thumbnail_contents.nil? || !self.thumbnail_filesystem_path.blank?)
  end

  def ensure_thumbnail
    Rails.logger.debug{"IdentityFile ensure_thumbnail"}
    if self.is_image? && self.thumbnail_contents.nil? && self.thumbnail_filesystem_path.blank? && !self.thumbnail_skip && self.is_thumbnailable?
      
      Rails.logger.debug{"image_content: Generating thumbnail for #{self.id}, type #{self.file_content_type}"}
      
      max_width = 400
      
      if self.filesystem_path.blank?
        image = Magick::Image::from_blob(self.get_file_contents)
        
        Rails.logger.debug{"image_content: Loaded image"}
        
        image = image.first
        
        Rails.logger.debug{"image_content: Acquired first image cols #{image.columns}"}
        
        if image.columns > max_width
          Rails.logger.debug{"image_content: Requires thumbnailing"}
          image.resize_to_fit!(max_width)
          blob = image.to_blob
          self.thumbnail_contents = blob
          self.thumbnail_size_bytes = blob.length
          self.save!
          Rails.logger.debug{"image_content: Saved thumbnail"}
        else
          Rails.logger.debug{"image_content: Thumbnail not required"}
          self.thumbnail_skip = true
          self.save!
        end
      else
        thumbnail_path = self.filesystem_path + "t"
        index = ""
        if !self.file_content_type.index("gif").nil? || !self.file_content_type.index("webm").nil?
          index = "[0]"
          thumbnail_path = thumbnail_path + ".jpg"
        end
        
        # https://imagemagick.org/script/command-line-processing.php#geometry
        # http://www.imagemagick.org/Usage/thumbnails/
        # http://www.imagemagick.org/Usage/resize/
        # Ulimit is in KB
        Open3.popen2e(%{
          ulimit -Sv 102400 && convert #{self.filesystem_path}#{index} -auto-orient -thumbnail '#{max_width}>' #{thumbnail_path}
        }) do |stdin, stdout_and_stderr, wait_thr|
          exit_status = wait_thr.value
          if exit_status != 0
            raise "Thumbnail exit status " + exit_status.to_s + ": #{stdout_and_stderr.read}"
          end
        end
        
        self.thumbnail_filesystem_path = thumbnail_path
        self.thumbnail_filesystem_size = File.size(thumbnail_path)
        self.save!
      end
    end
  end
  
  def self.create_for_path!(file_hash:)
    #   "file" => {
    #     "original_filename"=>"helloworld.txt",
    #     "content_type"=>"text/plain",
    #     "path"=>"/var/lib/remotenfs//uploads/0063322223",
    #     "md5"=>"e59ff97941044f85df5297e1c302d260",
    #     "size"=>"12"
    #   }
    IdentityFile.create!(
      file_file_name: file_hash[:original_filename],
      file_content_type: file_hash[:content_type],
      file_file_size: file_hash[:size],
      filesystem_path: file_hash[:path],
    )
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    if !self.filesystem_path.blank?
      File.delete(self.filesystem_path)
    end
    if !self.thumbnail_filesystem_path.blank?
      File.delete(self.thumbnail_filesystem_path)
    end
  end
end
