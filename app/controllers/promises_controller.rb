class PromisesController < MyplaceonlineController
  def model
    Promise
  end

  def display_obj(obj)
    result = obj.name
    if !obj.due.nil?
      result += " (" + I18n.t("myplaceonline.promises.due") + " " + Myp.display_date_short(obj.due, current_user) + ")"
    end
    result
  end

  protected
    def sorts
      ["promises.due ASC", "lower(promises.name) ASC"]
    end

    def obj_params
      params.require(:promise).permit(:name, :due, :promise)
    end
end
