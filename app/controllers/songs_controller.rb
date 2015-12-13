class SongsController < MyplaceonlineController
  def may_upload
    true
  end

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
        :awesome,
        musical_group_attributes: MusicalGroup.params,
        identity_file_attributes: [
          :id,
          :_destroy,
          :file,
          :notes
        ]
      )
    end
end
