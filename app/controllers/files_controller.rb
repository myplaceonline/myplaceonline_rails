class FilesController < MyplaceonlineController
  def path_name
    "file"
  end

  def category_name
    "files"
  end
  
  def display_obj(obj)
    obj.file_file_name
  end

  def model
    IdentityFile
  end
  
  protected

    def sorts
      ["identity_files.created_at ASC"]
    end

    def obj_params
      params.require(:file).permit()
    end
end
