class TripsController < MyplaceonlineController
  def model
    Trip
  end

  def may_upload
    true
  end
  
  protected
    def sorts
      ["trips.started DESC"]
    end

    def obj_params
      params.require(:trip).permit(
        :started,
        :ended,
        :notes,
        :work,
        Myp.select_or_create_permit(params[:trip], :location_attributes, LocationsController.param_names),
        trip_pictures_attributes: [
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
    
    def presave
      @obj.trip_pictures.each do |pic|
        if pic.identity_file.folder.nil?
          folders = Array.new
          folders.push(I18n.t("myplaceonline.category.trips"))
          if !@obj.location.region_name.blank?
            folders.push(@obj.location.region_name)
          end
          if !@obj.location.sub_region1_name.blank?
            folders.push(@obj.location.sub_region1_name)
          end
          if !@obj.location.sub_region2.blank?
            folders.push(@obj.location.sub_region2)
          end
          if folders.length == 1
            if !@obj.location.display_general_region.blank?
              folders.push(@obj.location.display_general_region)
            end
          end
          
          pic.identity_file.folder = IdentityFileFolder.find_or_create(folders)
        end
      end
    end
end
