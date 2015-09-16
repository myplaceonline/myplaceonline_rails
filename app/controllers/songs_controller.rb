class SongsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(songs.song_name) ASC"]
    end

    def obj_params
      params.require(:song).permit(
        :song_name,
        :song_rating,
        :lyrics,
        :song_plays,
        :lastplay,
        :secret,
        :awesome
      )
    end
end
