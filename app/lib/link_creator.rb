class LinkCreator
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers
  
  @@instance = LinkCreator.new
  
  def self.url(route, *args)
    if !route.ends_with?("_url")
      route << "_url"
    end
    @@instance.send(route, *args)
  end

  def self.path(route, *args)
    if !route.ends_with?("_path")
      route << "_path"
    end
    @@instance.send(route, *args)
  end

  protected
    def default_url_options
      Rails.configuration.default_url_options
    end
end
