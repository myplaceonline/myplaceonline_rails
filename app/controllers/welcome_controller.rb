class WelcomeController < ApplicationController
  skip_before_action :do_authenticate_user
  skip_authorization_check
  
  def index
    respond_to do |format|
      format.html {
        if user_signed_in?
          @myplets = Myplet.where(identity: current_user.current_identity).order(:x_coordinate, :y_coordinate).all
        end
        
        if !params[:emulate_host].blank?
          # http://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
          cookies[:emulate_host] = {
            value: params[:emulate_host]
          }
        end
        render :index
      }
      format.xml {
        if !Myp.website_domain.feed_url.blank?
          redirect_to Myp.website_domain.feed_url
        else
          raise "No feed found"
        end
      }
    end
  end
end
