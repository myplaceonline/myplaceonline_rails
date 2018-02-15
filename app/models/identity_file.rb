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
      if ENV["FILES_PREFIX"].blank? || (!ENV["FILES_PREFIX"].blank? && !File.absolute_path(self.filesystem_path).start_with?(ENV["FILES_PREFIX"]))
        raise "Path #{File.absolute_path(self.filesystem_path)} must start with #{ENV["PERMDIR"]}"
      end
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
    
    Rails.logger.debug{"IdentityFile.get_file_contents: Request for full image contents id #{self.id}"}
    
    result = nil
    
    if self.has_file?
      
      Rails.logger.debug{"IdentityFile.get_file_contents: has file"}
      
      if self.filesystem_path.blank?

        Rails.logger.debug{"IdentityFile.get_file_contents: file: #{self.file.inspect}"}

        result = self.file.file_contents
        
      else
        
        path = evaluated_path

        Rails.logger.debug{"IdentityFile.get_file_contents: filesystem_path #{path}"}

        result = IO.binread(path)
        
      end
    end
    
    Rails.logger.debug{"IdentityFile.get_file_contents: Returning #{ result.nil? ? 0 : result.length }"}
    
    result
  end
  
  def evaluated_path
    result = self.filesystem_path
    
    if !ENV["FILES_PREFIX"].blank? && !File.exist?(result)
      result = ENV["FILES_PREFIX"] + result
    end
    
    result
  end
  
  def evaluated_thumbnail_path
    result = self.thumbnail_filesystem_path
    
    if !ENV["FILES_PREFIX"].blank? && !File.exist?(result)
      result = ENV["FILES_PREFIX"] + result
    end
    
    result
  end
  
  def self.uploads_path
    if ENV["PERMDIR"].blank?
      raise "PERMDIR not set"
    end
    
    result = ENV["PERMDIR"] + "/uploads/";
    
    if !ENV["FILES_PREFIX"].blank? && !File.exist?(result)
      result = ENV["FILES_PREFIX"] + result
    end
    
    result
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    ensure_thumbnail
  end
  
  def has_file?
    
    # In the case of the DB-backed file, we don't want to do too much of a check
    # inspecting the file because that will load the bytes into memory and may
    # not be needed
    result = (!self.file.nil? && self.file.exists?) || !self.filesystem_path.blank?
    
    Rails.logger.debug{"IdentityFile.has_file?: #{result}"}
    
    result
    
  end

  def is_image?
    self.has_file? && !self.file_content_type.blank? && self.file_content_type.start_with?("image")
  end

  def is_thumbnailable?
    self.file_content_type.index("x-xcf").nil? && self.file_content_type.index("vnd.microsoft.icon").nil? && self.file_content_type.index("image/x-icon").nil?
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
    
    Rails.logger.debug{"IdentityFile ensure_thumbnail content_type: #{self.file_content_type}, is_image: #{self.is_image?}, thumbnail_contents_nil: #{self.thumbnail_contents.nil?}, thumbnail_filesystem_path_blank: #{self.thumbnail_filesystem_path.blank?}, thumbnail_skip: #{self.thumbnail_skip}, thumbnailable: #{self.is_thumbnailable?}"}
    
    if self.is_image? && self.thumbnail_contents.nil? && self.thumbnail_filesystem_path.blank? && !self.thumbnail_skip && self.is_thumbnailable? && self.has_file?
      
      Rails.logger.debug{"image_content: Generating thumbnail for #{self.id}, type #{self.file_content_type}"}
      
      max_width = 400
      
      if self.filesystem_path.blank?
        
        fc = self.get_file_contents
        
        if !fc.nil? && fc.length > 0
          Rails.logger.debug{"image_content: file contents: #{fc.inspect}"}
          
          image = Magick::Image::from_blob(fc)
          
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
        # Too small of a ulimit will cause errors such as:
        #   "libgomp: Thread creation failed: Resource temporarily unavailable"
        success = false
        
        command_line = "convert #{self.filesystem_path}#{index} -auto-orient -thumbnail '#{max_width}>' #{thumbnail_path}"
        
        child = Myp.spawn(
          command_line: command_line,
          process_error: false
        )
        if child.status.exitstatus == 0
          success = true
        else
          Myp.warn("Thumbnail id: #{self.id}, content_type: #{self.file_content_type}, name: #{self.file_file_name}, path: #{self.filesystem_path}, exit status #{child.status.exitstatus}, command line: #{command_line}, stdout: #{child.out}, stderr: #{child.err}")
        end
        
        if success
          self.thumbnail_filesystem_path = thumbnail_path
          self.thumbnail_filesystem_size = File.size(thumbnail_path)
          self.save!
        else
          self.thumbnail_skip = true
          self.save!
        end
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
      if File.exist?(self.filesystem_path)
        File.delete(self.filesystem_path)
      end
    end
    if !self.thumbnail_filesystem_path.blank?
      if File.exist?(self.thumbnail_filesystem_path)
        File.delete(self.thumbnail_filesystem_path)
      end
    end
  end
  
  def self.infer_content_type(path:)
    result = nil
    path = path.downcase
    pindex = path.rindex(".")
    if !pindex.nil?
      ext = path[pindex + 1..-1]
      case ext
      when "jpg", "jpeg"
        result = "image/jpeg"
      when "png"
        result = "image/png"
      when "gif"
        result = "image/gif"
      when "ods"
        result = "application/vnd.oasis.opendocument.spreadsheet"
      when "pdf"
        result = "application/pdf"
      when "mp3"
        result = "audio/mpeg"
      when "flv"
        result = "video/x-flv"
      when "zip"
        result = "application/zip"
      when "gpg"
        result = "application/pgp-encrypted"
      when "gz"
        result = "application/gzip"
      else
        raise "Unimplemented extension #{ext}"
      end
    else
      raise "No extension found for #{path}"
    end
    result
  end
  
  def self.name_to_random(name:, prefix: "R", extension: nil)
    if extension.nil?
      pindex = name.rindex(".")
      if !pindex.nil?
        extension = name[pindex..-1]
      end
    end
    result = prefix + SecureRandom.hex(10)
    if !extension.blank?
      result = result + extension
    end
    result
  end
  
  def copy(destination_file_name)
    if self.filesystem_path.blank?
      IO.binwrite(destination_file_name, self.file.file_contents)
    else
      FileUtils.cp(self.evaluated_path, destination_file_name)
    end
  end
  
  def download_name_path
    Rails.application.routes.url_helpers.send(
      "file_download_name_path",
      self,
      self.urlname,
      t: self.updated_at.to_i,
    )
  end
end
