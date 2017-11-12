class DnaAnalysesController < MyplaceonlineController
  def may_upload
    true
  end

  def show_edit
    false
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
