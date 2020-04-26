class WelcomeController < ApplicationController
  skip_before_action :do_authenticate_user
  skip_authorization_check
  
  def index
    respond_to do |format|
      format.html {
        if user_signed_in?
          @myplets = Myplet.where(identity: current_user.current_identity).order(:x_coordinate, :y_coordinate).all
        end
        
        render :index
      }
      format.xml {
        if !Myp.website_domain.feed_url.blank?
          redirect_to Myp.website_domain.feed_url
        else
          render plain: "404 not found", status: :not_found
        end
      }
      format.json {
        website_domain = Myp.website_domain
        render(
          json: {
            title: website_domain.domain_name,
            description: website_domain.meta_description,
            keywords: website_domain.meta_keywords,
          }
        )
      }
      format.feed {
        if !Myp.website_domain.feed_url.blank?
          redirect_to Myp.website_domain.feed_url
        else
          render plain: "404 not found", status: :not_found
        end
      }
    end
  end
end
