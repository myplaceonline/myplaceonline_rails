class ToDosController < MyplaceonlineController
  protected
    def sorts
      ["lower(to_dos.short_description) ASC"]
    end

    def obj_params
      params.require(:to_do).permit(
        :short_description,
        :due_time,
        :notes
      )
    end
end
