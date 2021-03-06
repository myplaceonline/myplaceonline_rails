require "open3"

class FilesController < MyplaceonlineController
  def path_name
    "file"
  end

  def paths_form_name
    path_name.pluralize
  end

  def category_name
    "files"
  end

  def model
    IdentityFile
  end
  
  def download
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
    respond_identity_file("attachment", @obj)
  end
  
  def view
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
    respond_identity_file("inline", @obj)
  end
  
  def thumbnail
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
    
    @obj.ensure_thumbnail
    
    if !@obj.thumbnail_contents.nil?
      Rails.logger.debug{"FilesController.thumbnail: found thumbnail_contents #{@obj.thumbnail_size_bytes}"}
      respond_identity_file("inline", @obj, thumbnail: true)
    elsif !@obj.thumbnail_filesystem_path.blank?
      Rails.logger.debug{"FilesController.thumbnail: found thumbnail_filesystem_path #{@obj.thumbnail_filesystem_path}"}
      respond_identity_file("inline", @obj, thumbnail: true)
    else
      Rails.logger.debug{"FilesController.thumbnail: no thumbnail, sending whole image"}
      respond_identity_file("inline", @obj)
    end
  end
  
  def thumbnail2
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
    
    @obj.ensure_thumbnail2
    
    if !@obj.thumbnail2_contents.nil?
      Rails.logger.debug{"FilesController.thumbnail2: found thumbnail2_contents #{@obj.thumbnail2_size_bytes}"}
      respond_identity_file("inline", @obj, thumbnail2: true)
    elsif !@obj.thumbnail2_filesystem_path.blank?
      Rails.logger.debug{"FilesController.thumbnail2: found thumbnail2_filesystem_path #{@obj.thumbnail2_filesystem_path}"}
      respond_identity_file("inline", @obj, thumbnail2: true)
    else
      Rails.logger.debug{"FilesController.thumbnail2: no thumbnail, sending whole image"}
      respond_identity_file("inline", @obj)
    end
  end
  
  def move
    set_obj
    
    check_password(level: MyplaceonlineController::CHECK_PASSWORD_OPTIONAL)
    
    @folders = Hash[IdentityFileFolder.where(
      identity_id: current_user.current_identity.id
    ).order(FileFoldersController.sorts).map{|f| [f.folder_name, f.id]}]
    
    if request.post?
      
      @folder = params[:destination]
      
      if @folder.blank?
        ApplicationRecord.transaction do
          @obj.folder = nil
          @obj.save!
        end
        redirect_to file_path(@obj),
          :flash => { :notice =>
                      I18n.t("myplaceonline.files.file_moved",
                            :folder => @folder)
                    }
      else
        
        @folder = @folder.to_i
        foundfolder = @folders.find{|k,v| v == @folder}
        if !foundfolder.nil?
          ApplicationRecord.transaction do
            @obj.folder = IdentityFileFolder.find(@folder)
            @obj.save!
          end
        else
          raise "TODO"
        end
        
        redirect_to file_path(@obj),
          :flash => { :notice =>
                      I18n.t("myplaceonline.files.file_moved",
                            :folder => @folder)
                    }
      end
    else
      render :move
    end
  end
  
  def rotate
    set_obj
    degrees_str = params[:degrees]
    if !degrees_str.blank?
      
      degrees = degrees_str.to_i
      if degrees >= -360 && degrees <= 360
        
        Rails.logger.debug{"FilesController.rotate: degrees: #{degrees}"}
        
        if @obj.filesystem_path.blank?
          
          Rails.logger.debug{"FilesController.rotate: no filesystem_path"}
          
          image = Magick::Image.from_blob(@obj.get_file_contents).first
          
          Rails.logger.debug{"FilesController.rotate: loaded image: #{image.inspect}"}
          
          Myp.tmpfile("file" + @obj.id.to_s + "_", "") do |tfile|

            Rails.logger.debug{"FilesController.rotate: temp file: #{tfile.path}"}
            
            image.background_color = "none"
            image.rotate!(degrees)
            
            Rails.logger.debug{"FilesController.rotate: completed rotation"}
            
            # Reset any EXIF orientation data when rotating
            if image.respond_to?("orientation=")
              image.orientation = Magick::UndefinedOrientation
            end
            
            image.write(tfile.path)
            
            tfile.flush
            
            Rails.logger.debug{"FilesController.rotate: wrote to temporary file size: #{File.size(tfile)}"}
            
            uploaded_file = ActionDispatch::Http::UploadedFile.new(
              tempfile: tfile,
              filename: @obj.file_file_name,
              type: @obj.file_content_type
            )
            
            @obj.clear_thumbnail
            
            Rails.logger.debug{"FilesController.rotate: cleared thumbnail"}
            
            @obj.file = uploaded_file
            
            @obj.save!
            
            Rails.logger.debug{"FilesController.rotate: updated file with #{uploaded_file.inspect}"}
          end
        else
          
          Rails.logger.debug{"FilesController.rotate: filesystem_path: #{@obj.filesystem_path}"}
          
          child = Myp.spawn(
            command_line: "/usr/bin/mogrify -auto-orient -rotate #{degrees} #{@obj.filesystem_path}"
          )
          
          @obj.clear_thumbnail
          @obj.save!
        end

        redirect_to file_path(@obj),
          :flash => { :notice =>
                      I18n.t("myplaceonline.files.saved")
                    }
      else
        redirect_to file_path(@obj),
          :flash => { :notice =>
                      I18n.t("myplaceonline.files.no_degrees")
                    }
      end
    else
      redirect_to file_path(@obj),
        :flash => { :notice =>
                    I18n.t("myplaceonline.files.no_degrees")
                  }
    end
  end
  
  def may_upload
    true
  end
  
  def second_list_before
    true
  end
  
  def second_path_name
    "file_folder"
  end
  
  def second_list_icon(obj)
    FilesController.second_list_icon(obj)
  end

  def self.second_list_icon(obj)
    ActionController::Base.helpers.image_tag("famfamfam/folder.png", alt: obj.display, title: obj.display, class: "ui-li-icon", height: 16, width: 16)
  end
  
  def self.param_names
    [
      :id,
      :_updatetype,
      :file,
      :file_file_name,
      :notes,
      :_destroy,
      folder_attributes: [ :id ]
    ]
  end
  
  def self.multi_param_names
    [
      :id,
      :_destroy,
      :position,
      identity_file_attributes: FilesController.param_names
    ]
  end

  def footer_items_index
    
    result = super
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t('myplaceonline.file_folders.add'),
        link: new_file_folder_path,
        icon: "plus"
      }
    end
    
    result
  end
  
  def footer_items_show
    result = super
    
    if !MyplaceonlineExecutionContext.offline?
      
      result << {
        title: I18n.t("myplaceonline.files.rotateclock90"),
        link: file_rotate_path(@obj, degrees: 90),
        icon: "forward"
      }
      
      result << {
        title: I18n.t("myplaceonline.files.rotatecounterclock90"),
        link: file_rotate_path(@obj, degrees: -90),
        icon: "back"
      }
      
      result << {
        title: I18n.t("myplaceonline.files.rotate180"),
        link: file_rotate_path(@obj, degrees: 180),
        icon: "gear"
      }
      
      result << {
        title: I18n.t("myplaceonline.files.move"),
        link: file_move_path(@obj),
        icon: "arrow-r"
      }
    end
    
    if !@obj.folder.nil?
      result << {
        title: I18n.t("myplaceonline.files.folder"),
        link: file_folder_path(@obj.folder),
        icon: "back"
      }
    end
    
    result
  end
  
  protected

    def all_additional_sql(strict)
      if params[:all].blank?
        "and folder_id is null"
      else
        nil
      end
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.identity_files.file_file_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(identity_files.file_file_name)"]
    end

    def obj_params
      params.require(:identity_file).permit(FilesController.param_names)
    end

    def index_pre_respond()
      if @offset == 0
        @objs2 = IdentityFileFolder.where(
          identity_id: current_user.current_identity.id,
          parent_folder: nil
        ).order(FileFoldersController.sorts)
      end
    end
end
