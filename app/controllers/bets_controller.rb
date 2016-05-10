class BetsController < MyplaceonlineController
  protected
    def sorts
      ["lower(bets.bet_name) ASC"]
    end

    def obj_params
      params.require(:bet).permit(
        :bet_name,
        :notes,
        :bet_start_date,
        :bet_end_date,
        :bet_amount,
        :odds_ratio,
        :odds_direction_owner
      )
    end
end
