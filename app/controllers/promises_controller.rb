class PromisesController < MyplaceonlineController
  def model
    Promise
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(promises.name) ASC"]
    end

    def obj_params
      params.require(:promise).permit(:name, :due, :promise)
    end
end
