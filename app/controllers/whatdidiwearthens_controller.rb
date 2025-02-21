class WhatdidiwearthensController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    str = ""
    
    obj.whatdidiwearthen_contacts.each do |contact_wrapper|
      str = Myp.appendstr(str, contact_wrapper.contact.display, "; ")
    end
    
    obj.whatdidiwearthen_locations.each do |location_wrapper|
      str = Myp.appendstr(str, location_wrapper.location.display_super_simple, "; ")
    end
    
    return str
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.whatdidiwearthens.weartime"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["whatdidiwearthens.weartime"]
    end

    def obj_params
      params.require(:whatdidiwearthen).permit(
        :weartime,
        :notes,
        :rating,
        whatdidiwearthen_files_attributes: FilesController.multi_param_names,
        whatdidiwearthen_contacts_attributes: [
          :id,
          :_destroy,
          contact_attributes: ContactsController.param_names
        ],
        whatdidiwearthen_locations_attributes: [
          :id,
          :_destroy,
          location_attributes: LocationsController.param_names
        ],
      )
    end
end
