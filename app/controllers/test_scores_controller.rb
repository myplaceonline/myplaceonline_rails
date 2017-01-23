class TestScoresController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["test_scores.test_score_date DESC"]
    end

    def obj_params
      params.require(:test_score).permit(
        :test_score_name,
        :test_score_date,
        :notes,
        test_score_files_attributes: FilesController.multi_param_names
      )
    end
end
