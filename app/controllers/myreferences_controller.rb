class MyreferencesController < MyplaceonlineController
  def self.param_names
    [
      :id,
      :_destroy,
      :reference_type,
      :notes,
      :reference_relationship,
      :years_experience,
      :can_contact,
      contact_attributes: ContactsController.param_names
    ]
  end

  def search_index_name
    Identity.table_name
  end

  def search_parent_category
    category_name.singularize
  end

  protected
    def obj_params
      params.require(:myreference).permit(
        MyreferencesController.param_names
      )
    end
end
