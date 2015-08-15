class RandomController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:activity]
  
  def index
  end

  def activity
    if request.method != "GET"
      candidates = Array.new
      candidates = candidates + current_user.primary_identity.activities.to_a
      if candidates.length > 0
        @result = candidates[rand(candidates.length)]
        category_name = @result.class.name.pluralize.underscore
        @category = Myp.categories(User.current_user)[category_name.to_sym]
        @result_link = "/" + category_name + "/" + @result.id.to_s
      end
    end
  end
end
