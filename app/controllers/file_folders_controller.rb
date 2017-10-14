class FileFoldersController < MyplaceonlineController
  def path_name
    "file_folder"
  end

  def paths_form_name
    path_name.pluralize
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

  def footer_items_show
    result = [
      {
        title: I18n.t('myplaceonline.files.add_file'),
        link: new_file_path(folder: @obj.id),
        icon: "plus"
      }
    ] + super
    
    if !@obj.parent_folder.nil?
      result << {
        title: I18n.t('myplaceonline.file_folders.parent_folder'),
        link: file_folder_path(@obj.parent_folder),
        icon: "back"
      }
    end
    
    result
  end
  
  protected

    def all_additional_sql(strict)
      "and parent_folder_id is null"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.identity_file_folders.folder_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      FileFoldersController.sorts
    end
    
    def self.sorts
      ["lower(identity_file_folders.folder_name)"]
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
