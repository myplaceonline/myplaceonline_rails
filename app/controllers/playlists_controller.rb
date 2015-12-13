class PlaylistsController < MyplaceonlineController
  protected
    def sorts
      ["lower(playlists.playlist_name) ASC"]
    end

    def obj_params
      params.require(:playlist).permit(
        :playlist_name,
        :notes,
        playlist_songs_attributes: [
          :id,
          :_destroy,
          :position,
          song_attributes: SongsController.params
        ]
      )
    end
end
