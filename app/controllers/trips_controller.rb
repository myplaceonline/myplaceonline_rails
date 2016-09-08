class TripsController < MyplaceonlineController
  def may_upload
    true
  end
  
  def shared
    @obj = model.find_by(id: params[:id])
    authorize! :show, @obj
    
    @pics = @obj.trip_pictures.to_a.dup.keep_if{|p| can?(:show, p.identity_file)}
    
  end
  
  def share
    set_obj
    
    @checked_values = {}
    @obj.trip_pictures.each do |trip_picture|
      @checked_values[trip_picture.id] = true
      if request.post?
        @checked_values[trip_picture.id] = Myp.param_bool(params, "pic#{trip_picture.id}")
      end
    end
    
    if request.post?
      redirect_to(
        permissions_share_token_path(
          subject_class: @obj.class.name,
          subject_id: @obj.id,
          child_selections: @checked_values.delete_if{|k,v| !v}.keys.join(",")
        )
      )
    end
  end

  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end
  
  def show_share
    false
  end

  protected
    def sorts
      ["trips.started DESC"]
    end

    def insecure
      true
    end
    
    def obj_params
      params.require(:trip).permit(
        :started,
        :ended,
        :notes,
        :work,
        :notify_emergency_contacts,
        location_attributes: LocationsController.param_names,
        trip_pictures_attributes: FilesController.multi_param_names + [:position],
        hotel_attributes: HotelsController.param_names,
        trip_stories_attributes: [
          :id,
          :_destroy,
          story_attributes: StoriesController.param_names
        ],
        trip_flights_attributes: [
          :id,
          :_destroy,
          flight_attributes: FlightsController.param_names
        ]
      )
    end

    def edit_prerespond
      @obj.notify_emergency_contacts = false
    end
end
