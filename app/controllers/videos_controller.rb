class VideosController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    if obj.finished?
      nil
    else
      I18n.t("myplaceonline.videos.unfinished")
    end
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def default_sort_columns
      ["videos.updated_at"]
    end

    def obj_params
      params.require(:video).permit(
        :video_name,
        :video_link,
        :stopped_watching_time,
        :finished,
        :notes,
        video_files_attributes: FilesController.multi_param_names,
      )
    end
end
