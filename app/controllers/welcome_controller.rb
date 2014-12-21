class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check
  
  def index
    if user_signed_in?
      @initialCategoryList = Myp.categories_for_current_user(current_user, -1).to_json
      @totalPoints = current_user.total_points
      @usefulCategoryList = Myp.useful_categories(current_user)
    end
    @isInitialPhonegapRequest = params[:phonegap] == "true"
  end
end
