class ApartmentsController < MyplaceonlineController
  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  def may_upload
    true
  end

  protected
    def sorts
      ["apartments.updated_at DESC"]
    end
    
    def obj_params
      params.require(:apartment).permit(
        :notes,
        location_attributes: LocationsController.param_names,
        landlord_attributes: ContactsController.param_names,
        apartment_leases_attributes: [:id, :start_date, :end_date, :monthly_rent, :moveout_fee, :deposit, :terminate_by, :_destroy],
        apartment_trash_pickups_attributes: [
          :id,
          :_destroy,
          :trash_type,
          :notes,
          repeat_attributes: Repeat.params
        ],
        apartment_pictures_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ]
      )
    end
end
