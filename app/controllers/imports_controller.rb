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
      @obj.start
      redirect_to import_import_path(@obj)
    else
      render :import
    end
  end
  
  def self.param_names
    [
      :import_name,
      :import_type,
      :notes,
      import_files_attributes: FilesController.multi_param_names,
    ]
  end
  
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.imports.import_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(imports.import_name)"]
    end

    def obj_params
      params.require(:import).permit(ImportsController.param_names)
    end
end
