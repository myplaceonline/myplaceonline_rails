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
  
  def after_update_redirect
    myplets = MyplaceonlineExecutionContext.identity.myplets.to_a
    if myplets.index{|myplet| myplet.category_name == category.name && myplet.category_id == @obj.id }.nil?
      super
    else
      redirect_to root_path
    end
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
    
    def prerespond
      if @obj.import.nil? || @obj.import.id.nil?
        @obj.import = Import.new(
          import_name: "23andme DNA",
          import_type: Import::IMPORT_TYPE_23ANDMEDNA,
        )
      end
    end

    def edit_prerespond
      prerespond
    end

    def new_prerespond
      prerespond
    end
    
    def before_show
      super
      if !@obj.import.nil? && @obj.import.import_status == Import::IMPORT_STATUS_IMPORTED
        @snp_count = GenotypeCall.where(dna_analysis: @obj).count
      end
    end
    
    def form_menu_items_cancel?
      if @myplet
        false
      else
        super
      end
    end
end
