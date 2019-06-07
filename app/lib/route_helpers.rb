module RouteHelpers
  # Most of the models follow a certain pattern, so a big chunk of the code here
  # is iterating through all models and creating `resources` and related items for each one
  # based on a pattern.

  def self.process_resources(routes, name, context)
    resources_as = name.to_s
    resources_path = name.to_s
    resources_controller = name.to_s
    
    if context.nil?
      context = []
    end
    
    context << { instance: true, link: "archive" }
    context << { instance: true, link: "unarchive" }
    context << { instance: true, link: "favorite" }
    context << { instance: true, link: "unfavorite" }
    context << { instance: true, link: "create_share" }
    context << { instance: true, link: "create_share_link" }
    context << { instance: true, link: "make_public" }
    context << { instance: true, link: "remove_public" }
    context << { instance: true, link: "move_identity" }
    context << { instance: false, link: "public" }
    context << { instance: false, link: "most_visited" }
    context << { instance: false, link: "settings" }
    context << { instance: false, link: "map" }

    context.each do |context_addition|
      if !context_addition[:instance].nil?
        if context_addition[:instance]
          routes.match "#{resources_path}/:id/#{context_addition[:link]}", :to => "#{resources_controller}##{context_addition[:link]}", via: [:get, :post, :patch], as: "#{resources_as.to_s.singularize}_#{context_addition[:link]}"
        else
          routes.match "#{resources_path}/#{context_addition[:link]}", :to => "#{resources_controller}##{context_addition[:link]}", via: [:get, :post], as: "#{resources_as}_#{context_addition[:link]}"
        end
      elsif !context_addition[:resourcesinfo].nil?
        if !context_addition[:as].nil?
          resources_as = context_addition[:as]
        end
        if !context_addition[:path].nil?
          resources_path = context_addition[:path]
        end
        if !context_addition[:controller].nil?
          resources_controller = context_addition[:controller]
        end
      end
    end
    
    routes.resources name.to_sym, :as => resources_as, :path => resources_path, :controller => resources_controller do
      context.each do |context_addition|
        if !context_addition[:subresources].nil?
          self.process_resources(routes, context_addition[:name], context_addition[:subitems])
        end
      end
    end
    
    routes.post "#{resources_as}/new"
  end

  def self.routes_index(routes, items)
    items.each do |item|
      routes.match "#{item}/index", via: [:get, :post]
      routes.match "#{item}", via: [:get, :post], :to => "#{item}#index"
    end
  end

  def self.routes_get(routes, items)
    items.each do |item|
      routes.get item
    end
  end

  def self.routes_post(routes, items)
    items.each do |item|
      routes.post item
    end
  end

  def self.routes_get_post(routes, items)
    items.each do |item|
      routes.match "#{item}", via: [:get, :post]
    end
  end
  
  def self.noop
  end
end
