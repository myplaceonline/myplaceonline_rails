class MemesController < MyplaceonlineController
  def may_upload
    true
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
        [I18n.t("myplaceonline.memes.meme_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["memes.meme_name"]
    end

    def obj_params
      params.require(:meme).permit(
        :meme_name,
        :notes,
        :rating,
        meme_files_attributes: FilesController.multi_param_names,
      )
    end
end
