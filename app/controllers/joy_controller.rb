class JoyController < ApplicationController
  def index
    @initialCategoryList = Myp.categoriesForCurrentUser(current_user, Category.find_by_name("joy")).to_json
  end
end
