class MusicAlbumsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(music_albums.music_album_name) ASC"]
    end

    def obj_params
      params.require(:music_album).permit(
        :music_album_name,
        :notes,
        music_album_files_attributes: FilesController.multi_param_names
      )
    end
end
