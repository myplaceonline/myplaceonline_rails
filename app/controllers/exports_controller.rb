class ExportsController < MyplaceonlineController
  def may_upload
    true
  end

  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.exports.export"),
        link: export_export_path(@obj),
        icon: "gear"
      },
    ] + super
  end
  
  def export
    set_obj
    
    if params[:exec] == "start"
      @obj.start
      redirect_to export_export_path(@obj)
    else
      render :export
    end
  end
  
  def self.param_names
    [
      :id,
      :export_name,
      :export_type,
      :notes,
      :_updatetype,
      export_files_attributes: FilesController.multi_param_names,
    ]
  end
  
  protected
    def sensitive
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.exports.export_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(exports.export_name)"]
    end

    def obj_params
      params.require(:export).permit(ExportsController.param_names)
    end
end
