class CustomDeviseFailure < Devise::FailureApp
  def respond
    flash[:alert] = i18n_message(:invalid)
    redirect_to redirect_url
  end
end
