class TripsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:map]

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

  def footer_items_show
    result = super + [
      {
        title: I18n.t("myplaceonline.general.share"),
        link: trip_share_path(@obj),
        icon: "action"
      },
      {
        title: I18n.t("myplaceonline.trips.show_shared"),
        link: trip_shared_path(@obj),
        icon: "search"
      },
      {
        title: I18n.t("myplaceonline.trips.pictures"),
        link: trip_trip_pictures_path(@obj),
        icon: "grid"
      },
      {
        title: I18n.t("myplaceonline.trips.add_picture"),
        link: new_trip_trip_picture_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.trips.add_story"),
        link: new_trip_trip_story_path(@obj),
        icon: "plus"
      }
    ]
    if !@obj.explicitly_completed
      result << {
        title: I18n.t("myplaceonline.trips.complete"),
        link: trip_complete_path(@obj),
        icon: "check"
      }
    end
    result
  end
  
  def complete
    set_obj
    if current_user.has_emergency_contacts?
      @notify_emergency_contacts = true
    end
    if request.post?
      @notify_emergency_contacts = param_bool(:notify_emergency_contacts)
      @obj.explicitly_completed = true
      @obj.save!
      if @notify_emergency_contacts
        @obj.notify_emergency_contacts_complete
      end
      redirect_to trip_path(@obj),
        :flash => { :notice => I18n.t("myplaceonline.trips.trip_completed") }
    end
  end
  
  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.general.map"),
        link: trips_map_path,
        icon: "navigation"
      }
    ]
  end
  
  def map
    @locations = self.all.map{ |x|
      if x.location.ensure_gps
        label = nil
        MapLocation.new(
          latitude: x.location.latitude,
          longitude: x.location.longitude,
          label: label,
          tooltip: x.display,
          popupHtml: ActionController::Base.helpers.link_to(x.display, x.location.map_url, target: "_blank")
        )
      else
        nil
      end
    }.compact
  end
  
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.trips.started"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["trips.started"]
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
        :trip_name,
        :notify_emergency_contacts,
        location_attributes: LocationsController.param_names,
        trip_pictures_attributes: FilesController.multi_param_names,
        hotel_attributes: HotelsController.param_names,
        event_attributes: EventsController.param_names,
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
