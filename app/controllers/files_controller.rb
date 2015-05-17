class FilesController < MyplaceonlineController

  def path_name
    "file"
  end

  def category_name
    "files"
  end
  
  def display_obj(obj)
    obj.display
  end

  def model
    IdentityFile
  end
  
  def download
    respond_download('attachment')
  end
  
  def view
    respond_download('inline')
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

  protected

    def all
      model.where(
        identity_id: current_user.primary_identity.id,
        folder: nil
      )
    end

    def sorts
      ["lower(identity_files.file_file_name) ASC"]
    end

    def obj_params
      params.require(:identity_file).permit(
        :file,
        :notes,
        folder_attributes: [ :id ]
      )
    end

    def respond_download(type)
      set_obj
      response.headers['Content-Length'] = @obj.file_file_size.to_s
      send_data(
        @obj.file.file_contents,
        :type => @obj.file_content_type,
        :filename => @obj.file_file_name,
        :disposition => type
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
    
    def new_obj_initialize
      if !params[:folder].nil?
        folders = IdentityFileFolder.where(
          identity_id: current_user.primary_identity.id,
          id: params[:folder].to_i
        )
        if folders.size > 0
          @obj.folder = folders.first
        end
      end
    end
end
