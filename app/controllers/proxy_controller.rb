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

    u = URI.parse(path)
    fullpath = u.path
    if !u.query.blank?
      fullpath = fullpath + "?" + u.query
    end

    # https://github.com/rest-client/rest-client
    response = Myp.http_get(url: path)
    raw_response = response[:raw_response]

    Rails.logger.debug{"Proxy result: #{raw_response.body}"}

    render(plain: raw_response.body, content_type: raw_response.headers[:content_type], status: raw_response.code)

    #reverse_proxy u.scheme + "://" + u.host, path: fullpath do |config|
    #  config.on_missing do |code, response|
    #    Rails.logger.warn{"Proxy response on_missing: #{response.uri} #{response.body}"}
    #    return render(
    #      json: { message: "Not found" },
    #      status: 404,
    #    )
    #  end
    #end
  end
end
