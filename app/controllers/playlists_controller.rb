class PlaylistsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:share]
  
  def share
    set_obj
    @share = Myp.new_model(PlaylistShare)
    @share.email = true
    if request.post?
      @share = PlaylistShare.new(
        params.require(:playlist_share).permit(
          :subject,
          :body,
          :email,
          playlist_share_contacts_attributes: [
            :_destroy,
            contact_attributes: [
              :id
            ]
          ]
        )
      )
      
      @share.playlist = @obj
      
      save_result = @share.save
      if save_result
        
        ZipPlaylistJob.perform_later(@share)
        
        redirect_to obj_path,
          :flash => { :notice =>
                      I18n.t("myplaceonline.playlists.shared_sucess")
                    }
      end
    end
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
          song_attributes: SongsController.params
        ]
      )
    end
end
