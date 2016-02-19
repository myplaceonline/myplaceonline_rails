class HappyThingsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(happy_things.happy_thing_name) ASC"]
    end

    def obj_params
      params.require(:happy_thing).permit(
        :happy_thing_name,
        :notes
      )
    end
end
