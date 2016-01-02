class PermissionsController < MyplaceonlineController
  def self.param_names(params)
    [
      { user_attributes: [:id] },
      :subject_class,
      :subject_id,
      :actionbit1,
      :actionbit2,
      :actionbit4,
      :actionbit8,
      :actionbit16,
    ]
  end

  protected
    def sorts
      ["permissions.updated_at DESC"]
    end

    def obj_params
      params.require(:permission).permit(
        PermissionsController.param_names(params[:permission])
      )
    end
end
