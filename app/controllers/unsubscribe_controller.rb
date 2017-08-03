class UnsubscribeController < ApplicationController
  skip_before_action :do_authenticate_user
  skip_authorization_check
  
  def index
    category = params[:category]
    token = params[:token]
    
    @content = ""
    
    token = EmailToken.where(token: token).first
    
    if !token.nil?
      flash.clear
      
      email = token.email
      
      if EmailUnsubscription.where(email: email, category: category, identity: token.identity).count == 0
        eu = EmailUnsubscription.new
        eu.email = email
        eu.category = category
        eu.identity = token.identity
        eu.save!
      end
      
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
