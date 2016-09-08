class MediaDumpsController < MyplaceonlineController
  def may_upload
    true
  end
  
  protected
    def sorts
      ["lower(media_dumps.media_dump_name) ASC"]
    end

    def insecure
      true
    end
    
    def obj_params
      params.require(:media_dump).permit(
        :media_dump_name,
        :notes,
        media_dump_files_attributes: FilesController.multi_param_names + [:position]
      )
    end
end
