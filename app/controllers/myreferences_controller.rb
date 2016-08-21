class MyreferencesController < MyplaceonlineController
  def self.param_names
    [
      :id,
      :_destroy,
      :reference_type,
      :notes,
      contact_attributes: ContactsController.param_names
    ]
  end

  def self.reject_if_blank(attributes)
    attributes.all?{|key, value|
      if key == "contact_attributes"
        ContactsController.reject_if_blank(value)
      else
        value.blank?
      end
    }
  end

  def search_index_name
    Identity.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def sorts
      ["myreferences.updated_at DESC"]
    end

    def obj_params
      params.require(:myreference).permit(
        MyreferencesController.param_names
      )
    end
end
