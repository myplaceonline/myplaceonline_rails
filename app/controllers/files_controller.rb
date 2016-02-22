class FilesController < MyplaceonlineController
  skip_authorization_check :only => [:download, :view]
  skip_before_filter :do_authenticate_user, :only => [:download, :view]

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
    if !current_user.nil? && @obj.identity_id == current_user.primary_identity.id
      respond_download_identity_file('attachment', @obj)
    else
      found = false
      token = params[:token]
      if !token.blank?
        @obj.identity_file_shares.each do |ifs|
          if ifs.share.token == token
            found = true
          end
        end
      end
      if !found
        raise CanCan::AccessDenied
      else
        respond_download_identity_file('attachment', @obj)
      end
    end
  end
  
  def view
    @obj = model.find_by(id: params[:id])
    if !current_user.nil? && @obj.identity_id == current_user.primary_identity.id
      respond_download_identity_file('inline', @obj)
    else
      found = false
      token = params[:token]
      if !token.blank?
        @obj.identity_file_shares.each do |ifs|
          if ifs.share.token == token
            found = true
          end
        end
      end
      if !found
        raise CanCan::AccessDenied
      else
        respond_download_identity_file('inline', @obj)
      end
    end
  end
  
  def thumbnail
    set_obj
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

    def all_additional_sql
      "and folder_id is null"
    end

    def sorts
      ["lower(identity_files.file_file_name) ASC"]
    end

    def obj_params
      params.require(:identity_file).permit(
        :file,
        :notes,
        :file_file_name,
        folder_attributes: [ :id ]
      )
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
