class BusinessCardsController < MyplaceonlineController
  def may_upload
    true
  end

  def self.param_names
    [
      :id,
      :_destroy,
      contact_attributes: ContactsController.param_names,
      business_card_files_attributes: FilesController.multi_param_names
    ]
  end

  protected
    def obj_params
      params.require(:business_card).permit(
        BusinessCardsController.param_names
      )
    end
end
