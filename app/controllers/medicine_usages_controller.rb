class MedicineUsagesController < MyplaceonlineController
  def model
    MedicineUsage
  end

  def display_obj(obj)
    Myp.display_datetime_short(obj.usage_time, User.current_user)
  end

  protected
    def insecure
      true
    end

    def sorts
      ["medicine_usages.usage_time DESC"]
    end

    def obj_params
      params.require(:medicine_usage).permit(
        :usage_time,
        :usage_notes,
        medicine_usage_medicines_attributes: [
          :id,
          :_destroy,
          medicine_attributes: Medicine.params
        ]
      )
    end
    
    def new_obj_initialize
      @obj.usage_time = DateTime.now
    end
end
