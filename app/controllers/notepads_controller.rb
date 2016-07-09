class NotepadsController < MyplaceonlineController
  def index
    @archived = params[:archived]
    if !@archived.blank?
      @archived = @archived.to_bool
    end
    super
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(notepads.title) ASC"]
    end

    def obj_params
      params.require(:notepad).permit(
        :title,
        :notepad_data,
        :is_archived
      )
    end
    
    def update_security
    end

    def all_additional_sql(strict)
      if (@archived.blank? || !@archived) && !strict
        "and archived is null"
      else
        nil
      end
    end
end
