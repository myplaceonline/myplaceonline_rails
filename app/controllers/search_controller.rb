class SearchController < ApplicationController
  skip_authorization_check

  def index
    @initialCategoryList = Myp.categories_for_current_user(current_user, -1)
  end
  
  def show
    @initialCategoryList = Myp.categories_for_current_user(current_user, -1)
  end
end
