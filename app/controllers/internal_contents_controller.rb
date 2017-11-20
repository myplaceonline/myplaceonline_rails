class InternalContentsController < ApplicationController
  skip_authorization_check

  def static_homepage
    layout = false
    
    @myplet = params[:myplet]
    if @myplet
      layout = "myplet"
    end
    
    website_domain = Myp.website_domain
    
    render(inline: website_domain.processed_static_homepage, layout: layout, content_type: "text/html")
  end
end
