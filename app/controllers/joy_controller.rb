class JoyController < ApplicationController
  def index
    @initialCategoryList = Myp.categoriesForCurrentUser(current_user, Myp.categories[:joy]).to_json
  end
end
