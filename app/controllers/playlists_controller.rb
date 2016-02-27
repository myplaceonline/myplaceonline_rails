class PlaylistsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:share, :shared]
  skip_before_filter :do_authenticate_user, :only => [:shared]
  
  def may_upload
    true
  end
  
  def shared
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
  end

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
          song_attributes: SongsController.params + [:id]
        ]
      )
    end
end
