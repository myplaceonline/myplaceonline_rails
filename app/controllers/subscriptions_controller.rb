class SubscriptionsController < MyplaceonlineController
  def model
    Subscription
  end

  protected
    def sorts
      ["lower(subscriptions.name) ASC"]
    end

    def obj_params
      params.require(:subscription).permit(:name, :start_date, :end_date, :notes)
    end
end
