class MrobblesController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    nil
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.general.created_at"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["mrobbles.created_at"]
    end

    def obj_params
      params.require(:mrobble).permit(
        :mrobble_name,
        :mrobble_link,
        :stopped_watching_time,
        :finished,
        :notes,
        :rating,
        mrobble_files_attributes: FilesController.multi_param_names,
      )
    end
end
