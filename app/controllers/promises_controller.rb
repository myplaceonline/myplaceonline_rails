class PromisesController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.promises.due"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["promises.due", "lower(promises.name) ASC"]
    end

    def obj_params
      params.require(:promise).permit(:name, :due, :promise)
    end
end
