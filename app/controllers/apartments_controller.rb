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

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    latest_lease = obj.latest_lease
    if !latest_lease.nil?
      Myp.display_date_month_year_simple(latest_lease.start_date, User.current_user)
    else
      nil
    end
  end

  protected
    def sorts
      ["apartment_leases.start_date DESC NULLS LAST", "apartments.updated_at DESC"]
    end
    
    def obj_params
      params.require(:apartment).permit(
        :notes,
        location_attributes: LocationsController.param_names,
        landlord_attributes: ContactsController.param_names,
        apartment_leases_attributes: [
          :id,
          :start_date,
          :end_date,
          :monthly_rent,
          :moveout_fee,
          :deposit,
          :terminate_by,
          :_destroy,
          apartment_lease_files_attributes: FilesController.multi_param_names
        ],
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

    def all_joins
      "LEFT OUTER JOIN apartment_leases ON apartments.id = apartment_leases.apartment_id"
    end

    def all_includes
      :apartment_leases
    end
end
