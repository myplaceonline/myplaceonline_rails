class TripPicturesController < MyplaceonlineController
  def may_upload
    true
  end

  def path_name
    "trip_trip_picture"
  end

  def form_path
    "trip_pictures/form"
  end

  def index_destroy_all_link?
    true
  end

  def nested
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["trip_pictures.created_at DESC"]
    end

    def obj_params
      params.require(:trip_picture).permit(
        FilesController.multi_param_names
      )
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Trip
    end
end
