class ImportsController < MyplaceonlineController
  def may_upload
    true
  end

  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.imports.import"),
        link: import_import_path(@obj),
        icon: "gear"
      },
    ] + super
  end
  
  def import
    set_obj
    
    if params[:exec] == "start"
      ApplicationJob.perform(ImportJob, @obj, params[:exec])
    end
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["lower(imports.import_name) ASC"]
    end

    def obj_params
      params.require(:import).permit(
        :import_name,
        :import_type,
        :notes,
        import_files_attributes: FilesController.multi_param_names,
      )
    end
end
