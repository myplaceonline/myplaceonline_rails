class PromisesController < MyplaceonlineController
  protected
    def sorts
      ["promises.due ASC", "lower(promises.name) ASC"]
    end

    def obj_params
      params.require(:promise).permit(:name, :due, :promise)
    end
end
