class FileFoldersController < MyplaceonlineController
  def path_name
    "file_folder"
  end

  def category_name
    "file_folders"
  end
  
  def display_obj(obj)
    obj.display
  end

  def model
    IdentityFileFolder
  end
  
  def redirect_to_obj
    redirect_to file_folder_path(@obj)
  end
  
  def back_to_all_name
    I18n.t("myplaceonline.category.files")
  end
  
  def back_to_all_path
    files_path
  end
  
  def add_another_name
    I18n.t("myplaceonline.file_folders.add_subfolder")
  end
  
  def new_path(context = nil)
    if context.nil?
      send("new_" + path_name + "_path")
    else
      send("new_" + path_name + "_path", parent: context.id)
    end
  end

  protected

    def all
      model.where(
        identity_id: current_user.primary_identity.id,
        parent_folder: nil
      )
    end

    def sorts
      FileFoldersController.sorts
    end
    
    def self.sorts
      ["lower(identity_file_folders.folder_name) ASC"]
    end

    def obj_params
      params.require(:identity_file_folder).permit(
        :folder_name,
        parent_folder_attributes: [ :id ]
      )
    end
    
    def has_category
      false
    end
    
    def new_obj_initialize
      if !params[:parent].nil?
        folders = IdentityFileFolder.where(
          identity_id: current_user.primary_identity.id,
          id: params[:parent].to_i
        )
        if folders.size > 0
          @obj.parent_folder = folders.first
        end
      end
    end
end
