class FileFoldersController < MyplaceonlineController
  def path_name
    "file_folder"
  end

  def category_name
    "file_folders"
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

    def all_additional_sql
      "and parent_folder_id is null"
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
end
