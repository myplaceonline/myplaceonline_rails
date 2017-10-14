class QuestionsController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.questions.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(questions.name)"]
    end

    def obj_params
      params.require(:question).permit(
        :name,
        :notes,
        hypotheses_attributes: [
          :id,
          :name,
          :notes,
          :position,
          :_destroy,
          hypothesis_experiments_attributes: [
            :id,
            :name,
            :notes,
            :started,
            :ended,
            :_destroy
          ]
        ]
      )
    end
end
