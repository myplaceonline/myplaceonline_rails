class CustomDeviseFailure < Devise::FailureApp
  def respond
    if request.post?
      flash[:alert] = i18n_message(:invalid)
    else
      flash[:alert] = i18n_message
    end
    redirect_to redirect_url
  end
end
