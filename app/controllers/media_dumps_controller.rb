class MediaDumpsController < MyplaceonlineController
  def may_upload
    true
  end
  
  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.media_dumps.files"),
        link: media_dump_media_dump_files_path(@obj),
        icon: "grid"
      },
      {
        title: I18n.t("myplaceonline.media_dumps.add_file"),
        link: new_media_dump_media_dump_file_path(@obj),
        icon: "plus"
      }
    ]
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
        media_dump_files_attributes: FilesController.multi_param_names
      )
    end
end
