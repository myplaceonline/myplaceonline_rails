class SongsController < MyplaceonlineController
  def model
    Song
  end

  protected
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
