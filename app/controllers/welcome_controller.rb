class WelcomeController < MyplaceonlineController
  skip_before_filter :authenticate_user!
  def index
    if user_signed_in?
      @initialCategoryList = categoriesForCurrentUser.to_json
      @totalPoints = current_user.total_points
    end
  end
end
