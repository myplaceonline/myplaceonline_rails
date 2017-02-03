class FlightsController < MyplaceonlineController
  def send_info
    set_obj
    
    @message = Myp.new_model(Message)
    
    if request.post?
      @message = Message.new(
        params.require(:message).permit(
          MessagesController.param_names
        )
      )

      @message.message_category = I18n.t("myplaceonline.flights.message_category")

      last_leg = @obj.last_flight_leg
        
      if params[:send_last_leg] == "true" && !last_leg.nil?
        @message.subject = @message.body = I18n.t(
          "myplaceonline.flights.last_leg_info",
          name: User.current_user.primary_identity.display_short,
          airline: last_leg.flight_company.display,
          time: Myp.display_datetime_short(last_leg.arrive_time, User.current_user),
          location: last_leg.arrival_location.nil? ? last_leg.arrival_airport_code : last_leg.arrival_location.display_simple,
          flight_number: last_leg.flight_number
        )
      end

      if @message.save
        @message.process
        redirect_to(
          flight_path(@obj),
          :flash => { :notice => I18n.t("myplaceonline.flights.info_sent") }
        )
      end
    end
  end
  
  def self.param_names
    [
      :id,
      :flight_name,
      :flight_start_date,
      :confirmation_number,
      :notes,
      flight_legs_attributes: [
        :id,
        :_destroy,
        :flight_number,
        :depart_airport_code,
        :depart_time,
        :arrival_airport_code,
        :arrive_time,
        :seat_number,
        :position,
        flight_company_attributes: Company.param_names,
        depart_location_attributes: LocationsController.param_names,
        arrival_location_attributes: LocationsController.param_names
      ]
    ]
  end

  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.flights.send_info"),
        link: flight_send_info_path(@obj),
        icon: "action"
      }
    ]
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["flights.flight_start_date DESC", "lower(flights.flight_name) ASC"]
    end

    def obj_params
      params.require(:flight).permit(FlightsController.param_names)
    end
end
