class ExportsController < MyplaceonlineController
  def may_upload
    true
  end

  def footer_items_show
    result = []

    if @obj.export_status != Export::EXPORT_STATUS_EXPORTED
      if @obj.export_status == Export::EXPORT_STATUS_READY || User.current_user.admin?
        result << {
          title: I18n.t("myplaceonline.exports.start_export"),
          link: export_export_path(@obj, exec: "start"),
          icon: "gear",
        }
      end

      result << {
        title: I18n.t("myplaceonline.exports.export_status"),
        link: export_export_path(@obj),
        icon: "gear",
      }
    end

    result + super
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
      :compression_type,
      :encrypt_output,
      export_files_attributes: FilesController.multi_param_names,
    ]
  end
  
  def after_create_redirect
    @obj.start
    
    respond_to do |format|
      format.html {
        redirect_to(export_export_path(@obj))
      }
      format.js { render :saved_export }
    end
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
