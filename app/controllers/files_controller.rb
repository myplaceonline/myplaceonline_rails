class FilesController < MyplaceonlineController
  def path_name
    "file"
  end

  def display_obj(obj)
    "File"
  end

  def model
    IdentityFile
  end
  
  def category_name
    "files"
  end
  
  protected

    def sorts
      ["identity_files.created_at ASC"]
    end

    def obj_params
      params.require(:file).permit()
    end
end
