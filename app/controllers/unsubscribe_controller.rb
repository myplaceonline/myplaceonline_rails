class UnsubscribeController < ApplicationController
  skip_before_filter :do_authenticate_user
  skip_authorization_check
  
  def index
    email = params[:email]
    category = params[:category]
    token = params[:token]
    
    @content = ""
    
    token = EmailToken.where(token: token).first
    
    if !token.nil?
      flash.clear
      
      eu = EmailUnsubscription.new
      eu.email = email
      eu.category = category
      eu.identity = token.identity
      eu.save!
      
      if category.blank?
        @content = t("myplaceonline.unsubscribe.unsubscribed_all")
      else
        @content = t("myplaceonline.unsubscribe.unsubscribed_category", {category: category})
      end
      
    else
      flash[:error] = t("myplaceonline.unsubscribe.invalid_token")
    end
  end
end
