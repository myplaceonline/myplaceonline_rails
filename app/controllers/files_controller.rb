require "open3"

class FilesController < MyplaceonlineController
  #skip_authorization_check :only => [:download, :view, :thumbnail]
  #skip_before_action :do_authenticate_user, :only => [:download, :view, :thumbnail]

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
    if !@obj.thumbnail_contents.nil?
      Rails.logger.debug{"FilesController.thumbnail: found thumbnail_contents #{@obj.thumbnail_size_bytes}"}
      respond_data("inline", @obj.thumbnail_contents, @obj.thumbnail_size_bytes, @obj.file_file_name, @obj.file_content_type)
    elsif !@obj.thumbnail_filesystem_path.blank?
      
      thumbnail_path = @obj.thumbnail_filesystem_path
      
      if !ENV["FILES_PREFIX"].blank? && !File.exist?(thumbnail_path)
        thumbnail_path = ENV["FILES_PREFIX"] + thumbnail_path
      end
      
      send_file(
        thumbnail_path,
        :type => @obj.file_content_type,
        :filename => @obj.file_file_name,
        :disposition => "inline"
      )
    else
      Rails.logger.debug{"FilesController.thumbnail: no thumbnail, sending whole image"}
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
        
        if @obj.filesystem_path.blank?
          image = Magick::Image.from_blob(@obj.get_file_contents).first
          
          Myp.tmpfile("file" + @obj.id.to_s + "_", "") do |tfile|
            image.background_color = "none"
            image.rotate!(degrees)
            
            # Reset any EXIF orientation data when rotating
            if image.respond_to?("orientation=")
              image.orientation = Magick::UndefinedOrientation
            end
            
            image.write(tfile.path)
            
            tfile.flush
            
            uploaded_file = ActionDispatch::Http::UploadedFile.new(
              tempfile: tfile,
              filename: @obj.file_file_name,
              type: @obj.file_content_type
            )
            
            @obj.clear_thumbnail
            @obj.file = uploaded_file
            @obj.save!
          end
        else
          child = Myp.spawn(
            command_line: "/usr/bin/mogrify #{self.filesystem_path}#{index} -auto-orient -rotate #{degrees} #{@obj.filesystem_path}"
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
    super + [
      {
        title: I18n.t('myplaceonline.file_folders.add'),
        link: new_file_folder_path,
        icon: "plus"
      }
    ]
  end
  
  def footer_items_show
    result = super + [
      {
        title: I18n.t("myplaceonline.files.rotateclock90"),
        link: file_rotate_path(@obj, degrees: 90),
        icon: "forward"
      },
      {
        title: I18n.t("myplaceonline.files.rotatecounterclock90"),
        link: file_rotate_path(@obj, degrees: -90),
        icon: "back"
      },
      {
        title: I18n.t("myplaceonline.files.rotate180"),
        link: file_rotate_path(@obj, degrees: 180),
        icon: "gear"
      },
      {
        title: I18n.t("myplaceonline.files.move"),
        link: file_move_path(@obj),
        icon: "arrow-r"
      }
    ]
    
    if !@obj.folder.nil?
      result << {
        title: I18n.t('myplaceonline.files.folder'),
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
