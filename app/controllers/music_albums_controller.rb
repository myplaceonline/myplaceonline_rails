class MusicAlbumsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.music_albums.music_album_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(music_albums.music_album_name)"]
    end

    def obj_params
      params.require(:music_album).permit(
        :music_album_name,
        :notes,
        music_album_files_attributes: FilesController.multi_param_names
      )
    end
end
