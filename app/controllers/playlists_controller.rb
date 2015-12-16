class PlaylistsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:share, :shared]
  skip_before_filter :authenticate_user!, :only => [:shared]
  
  def may_upload
    true
  end

  def share
    set_obj
    @share = Myp.new_model(PlaylistShare)
    @share.email = true
    @share.copy_self = true
    if request.post?
      @share = PlaylistShare.new(
        params.require(:playlist_share).permit(
          :subject,
          :body,
          :email,
          :copy_self,
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
  
  def shared
    @obj = model.find_by(id: params[:id])
    found = false
    if !current_user.nil?
      found = @obj.owner_id == current_user.primary_identity.id
    end
    token = params[:token]
    if !token.blank?
      @obj.playlist_shares.each do |playlist_share|
        if !playlist_share.share.nil? && playlist_share.share.token == token
          found = true
        end
      end
    end
    if !found
      raise CanCan::AccessDenied
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
          song_attributes: SongsController.params + [:id]
        ]
      )
    end
end
