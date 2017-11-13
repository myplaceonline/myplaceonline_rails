class DnaAnalysesController < MyplaceonlineController
  def may_upload
    true
  end

  def show_edit
    false
  end
  
  def rerun
    set_obj
    
    @obj.import.start
    
    redirect_to(dna_analysis_path(@obj))
  end

  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.dna_analyses.rerun"),
        link: dna_analysis_rerun_path(@obj),
        icon: "recycle"
      },
    ] + super
  end
  
  protected
    def sensitive
      true
    end

    def obj_params
      params.require(:dna_analysis).permit(
        import_attributes: ImportsController.param_names
      )
    end

    def new_prerespond
      @obj.import = Import.new(
        import_name: "23andme DNA",
        import_type: Import::IMPORT_TYPE_23ANDMEDNA,
      )
    end
end
