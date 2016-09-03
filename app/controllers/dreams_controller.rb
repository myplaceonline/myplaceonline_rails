class DreamsController < MyplaceonlineController
  protected
    def sorts
      ["dreams.dream_time DESC"]
    end

    def sensitive
      true
    end

    def obj_params
      params.require(:dream).permit(
        :dream_name,
        :dream_time,
        :dream,
        :encrypt
      )
    end
end
