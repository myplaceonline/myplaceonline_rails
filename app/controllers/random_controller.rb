class RandomController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:activity]
  
  def index
  end

  def activity
    identity = current_user.current_identity
    candidates = Array.new
    any_filters = false
    @all_filters = [
      :activities,
      :books,
      :feeds,
      :ideas,
      :life_goals,
      :movies,
      :restaurants,
      :websites,
    ]
    params.each do |key, value|
      if key.start_with?("filter_")
        any_filters = true
        instance_variable_set("@" + key, true)
      end
    end
    if !any_filters
      @all_filters.each do |filter|
        instance_variable_set("@filter_" + filter.to_s, true)
      end
    end
    
    @all_filters.each do |filter|
      if instance_variable_get("@filter_" + filter.to_s)
        candidates = candidates + identity.send(filter.to_s).to_a
      end
    end
    
    if candidates.length > 0
      @result = candidates[rand(candidates.length)]
      category_name = @result.class.name.pluralize.underscore
      @category = Myp.categories(User.current_user)[category_name.to_sym]
      @result_link = "/" + category_name + "/" + @result.id.to_s
    end
  end
end
