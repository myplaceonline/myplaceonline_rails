class PlaylistsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:share, :shared]
  skip_before_action :do_authenticate_user, :only => [:shared]
  
  def may_upload
    true
  end
  
  def shared
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
  end

  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.general.share"),
        link: permissions_share_token_path(subject_class: @obj.class.name, subject_id: @obj.id),
        icon: "action"
      },
      {
        title: I18n.t("myplaceonline.playlists.show_shared"),
        link: playlist_shared_path(@obj),
        icon: "search"
      }
    ]
  end
  
  def show_share
    false
  end

  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.playlists.playlist_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(playlists.playlist_name)"]
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
