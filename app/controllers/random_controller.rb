class RandomController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:activity]
  
  def index
  end

  def activity
    identity = current_user.primary_identity
    candidates = Array.new
    any_filters = false
    params.each do |key, value|
      if key.start_with?("filter_")
        any_filters = true
        filter_name = key[7..-1]
        if filter_name == "activities"
          @filter_activities = true
        elsif filter_name == "websites"
          @filter_websites = true
        elsif filter_name == "movies"
          @filter_movies = true
        elsif filter_name == "books"
          @filter_books = true
        end
      end
    end
    if !any_filters
      @filter_activities = true
      @filter_websites = true
      @filter_movies = true
      @filter_books = true
    end
    if @filter_activities
      candidates = candidates + identity.activities.to_a
    end
    if @filter_websites
      candidates = candidates + identity.websites.to_a
    end
    if @filter_movies
      candidates = candidates + identity.movies.to_a
    end
    if @filter_books
      candidates = candidates + identity.books.to_a
    end
    if candidates.length > 0
      @result = candidates[rand(candidates.length)]
      category_name = @result.class.name.pluralize.underscore
      @category = Myp.categories(User.current_user)[category_name.to_sym]
      @result_link = "/" + category_name + "/" + @result.id.to_s
    end
  end
end
