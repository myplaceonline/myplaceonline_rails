class MediaDumpFilesController < MyplaceonlineController
  def may_upload
    true
  end

  def path_name
    "media_dump_media_dump_file"
  end

  def form_path
    "media_dump_files/form"
  end

  def index_destroy_all_link?
    true
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.media_dumps.media_dump"),
        link: media_dump_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.media_dumps.media_dump"),
        link: media_dump_path(@obj.media_dump),
        icon: "back"
      }
    ]
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:media_dump_file).permit(
        FilesController.multi_param_names
      )
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      MediaDump
    end
end
