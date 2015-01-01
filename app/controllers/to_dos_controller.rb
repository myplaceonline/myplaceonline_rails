class ToDosController < MyplaceonlineController
  def model
    ToDo
  end

  def display_obj(obj)
    obj.short_description
  end

  protected
    def sorts
      ["lower(to_dos.short_description) ASC"]
    end

    def obj_params
      params.require(:to_do).permit(:short_description, :notes)
    end
end
