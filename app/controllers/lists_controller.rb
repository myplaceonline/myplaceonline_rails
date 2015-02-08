class ListsController < MyplaceonlineController
  def model
    List
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(lists.name) ASC"]
    end

    def obj_params
      params.require(:list).permit(:name)
    end
end
