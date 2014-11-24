class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  def index
    if user_signed_in?
      @initialCategoryList = Myp.categoriesForCurrentUser(current_user, -1).to_json
      @totalPoints = current_user.total_points
    end
  end
end
