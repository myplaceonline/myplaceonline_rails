class RecreationalVehiclesController < MyplaceonlineController
  def model
    RecreationalVehicle
  end

  def display_obj(obj)
    obj.rv_name
  end

  def may_upload
    true
  end

  def self.param_names(params)
    [
      :rv_name,
      :notes,
      :owned_start,
      :owned_end,
      :vin,
      :manufacturer,
      :model,
      :year,
      :price,
      :dimensions_type,
      :msrp,
      :purchased,
      :wet_weight,
      :weight_type,
      :sleeps,
      :exterior_length,
      :exterior_length_over,
      :exterior_width,
      :exterior_height,
      :exterior_height_over,
      :interior_height,
      :liquid_capacity_type,
      :fresh_tank,
      :grey_tank,
      :black_tank,
      :warranty_ends,
      :water_heater,
      :propane,
      :volume_type,
      :refrigerator,
      :slideouts_extra_width,
      Myp.select_or_create_permit(params[:recreational_vehicle], :location_purchased_attributes, LocationsController.param_names),
      recreational_vehicle_loans_attributes: [
        :id,
        :_destroy,
        loan_attributes: Loan.params
      ],
      recreational_vehicle_pictures_attributes: [
        :id,
        :_destroy,
        identity_file_attributes: [
          :id,
          :file,
          :notes
        ]
      ]
    ]
  end
  
  def self.reject_if_blank(attributes)
    attributes.dup.delete_if {|key, value| key.to_s == "dimensions_type" || key.to_s == "weight_type" || key.to_s == "liquid_capacity_type" || key.to_s == "volume_type" || key.to_s == "location_purchased_attributes" }.all? {|key, value| value.blank?}
  end

  protected
    def sorts
      ["lower(recreational_vehicles.rv_name) ASC"]
    end

    def obj_params
      params.require(:recreational_vehicle).permit(RecreationalVehiclesController.param_names(params))
    end

    def presave
      @obj.recreational_vehicle_pictures.each do |pic|
        if pic.identity_file.folder.nil?
          pic.identity_file.folder = IdentityFileFolder.find_or_create([I18n.t("myplaceonline.category.recreational_vehicles"), @obj.display])
        end
      end
    end
end
