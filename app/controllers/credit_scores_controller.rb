class CreditScoresController < MyplaceonlineController
  def model
    CreditScore
  end

  protected
    def sorts
      ["credit_scores.score_date DESC"]
    end

    def obj_params
      params.require(:credit_score).permit(:score_date, :score, :source)
    end
    
    def new_obj_initialize
      @obj.score_date = Date.today
    end
end
