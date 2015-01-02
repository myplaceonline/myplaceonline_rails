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
  
  def download
    respond_download('attachment')
  end
  
  def view
    respond_download('inline')
  end
  
  def may_upload
    true
  end
  
  protected

    def sorts
      ["lower(identity_files.file_file_name) ASC"]
    end

    def obj_params
      params.require(:identity_file).permit(:file)
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
end
