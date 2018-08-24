class SongsController < MyplaceonlineController
  def may_upload
    true
  end
  
  def self.params
    [
      :song_name,
      :song_rating,
      :lyrics,
      :song_plays,
      :lastplay,
      :secret,
      :awesome,
      musical_group_attributes: MusicalGroup.params,
      identity_file_attributes: FilesController.param_names
    ]
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.songs.song_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(songs.song_name)"]
    end

    def obj_params
      params.require(:song).permit(SongsController.params)
    end
end
