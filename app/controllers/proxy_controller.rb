class ProxyController < ApplicationController
      include ReverseProxy::Controller

  skip_authorization_check
  skip_before_action :verify_authenticity_token

  def index
    path = params[:path]
    if path.blank?
      return render(
        json: { message: "Not found" },
        status: 404,
      )
    end

    path = path.gsub(/(https?):\/([^\/])/, "\\1://\\2")

    # Whitelist
    if !path.start_with?("https://maps.googleapis.com/maps/api")
      Rails.logger.warn{"Proxy path not white-listed: #{path}"}
      return render(
        json: { message: "Not found" },
        status: 404,
      )
    end

    Rails.logger.debug{"Proxying: #{path}"}

    p = params.to_unsafe_hash.dup.except(:controller, :action, :path)
    if p.size > 0
      path = "#{path}?#{p.to_query}"
      Rails.logger.debug{"Updating path: #{path}"}
    end

    reverse_proxy path, path: ""
  end
end
