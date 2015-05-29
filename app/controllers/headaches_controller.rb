class HeadachesController < MyplaceonlineController
  def model
    Headache
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def sorts
      ["headaches.started DESC"]
    end

    def obj_params
      params.require(:headache).permit(
        :started,
        :ended,
        :intensity,
        :headache_location
      )
    end
end
