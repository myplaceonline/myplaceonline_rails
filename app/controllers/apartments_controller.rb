class ApartmentsController < MyplaceonlineController
  def model
    Apartment
  end

  def display_obj(obj)
    "Test"
  end

  protected
    def sorts
      ["apartments.updated_at DESC"]
    end

    def obj_params
      params.require(:apartment).permit(:location)
    end
end
