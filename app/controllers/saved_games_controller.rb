class SavedGamesController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.game_time, User.current_user)
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.saved_games.game_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["saved_games.game_time"]
    end

    def obj_params
      params.require(:saved_game).permit(
        :game_name,
        :game_time,
        :notes,
        saved_game_files_attributes: FilesController.multi_param_names,
        contact_attributes: ContactsController.param_names
      )
    end
end
