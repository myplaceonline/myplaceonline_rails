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
  
  protected

    def sorts
      ["lower(identity_file_folders.folder_name) ASC"]
    end

    def obj_params
      params.require(:identity_file_folder).permit(:folder_name)
    end
    
    def has_category
      false
    end
end
