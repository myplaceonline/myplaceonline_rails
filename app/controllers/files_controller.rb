class FilesController < MyplaceonlineController
  #skip_authorization_check :only => [:download, :view, :thumbnail]
  #skip_before_filter :do_authenticate_user, :only => [:download, :view, :thumbnail]

  def path_name
    "file"
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
    respond_download_identity_file('attachment', @obj)
  end
  
  def view
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
    respond_download_identity_file('inline', @obj)
  end
  
  def thumbnail
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
    if !@obj.thumbnail_contents.nil?
      respond_download('inline', @obj.thumbnail_contents, @obj.thumbnail_bytes)
    else
      respond_download_identity_file('inline', @obj)
    end
  end
  
  def move
    set_obj
    Myp.ensure_encryption_key(session)
    
    @folders = Hash[IdentityFileFolder.where(
      identity_id: current_user.primary_identity.id
    ).order(FileFoldersController.sorts).map{|f| [f.folder_name, f.id]}]
    
    if request.post?
      
      @folder = params[:destination]
      
      if @folder.blank?
        ActiveRecord::Base.transaction do
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
          ActiveRecord::Base.transaction do
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
        
        image = Magick::Image.from_blob(@obj.file.file_contents).first
        
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
      :file,
      :file_file_name,
      :notes,
      folder_attributes: [ :id ]
    ]
  end
  
  def self.multi_param_names
    [
      :id,
      :_destroy,
      identity_file_attributes: FilesController.param_names
    ]
  end

  protected

    def all_additional_sql(strict)
      "and folder_id is null"
    end

    def sorts
      ["lower(identity_files.file_file_name) ASC"]
    end

    def obj_params
      params.require(:identity_file).permit(FilesController.param_names)
    end

    def respond_download_identity_file(respond_type, identity_file)
      if identity_file.filesystem_path.blank?
        respond_download(respond_type, identity_file.file.file_contents, identity_file.file_file_size)
      else
        send_file(
          identity_file.filesystem_path,
          :type => @obj.file_content_type,
          :filename => @obj.file_file_name,
          :disposition => respond_type
        )
      end
    end
    
    def respond_download(respond_type, data, data_bytes)
      response.headers['Content-Length'] = data_bytes.to_s
      send_data(
        data,
        :type => @obj.file_content_type,
        :filename => @obj.file_file_name,
        :disposition => respond_type
      )
    end
    
    def index_pre_respond()
      if @offset == 0
        @objs2 = IdentityFileFolder.where(
          identity_id: current_user.primary_identity.id,
          parent_folder: nil
        ).order(FileFoldersController.sorts)
      end
    end
end
