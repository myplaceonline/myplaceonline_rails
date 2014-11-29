class JoyController < ApplicationController
  skip_authorization_check

  def index
    @initialCategoryList = Myp.categoriesForCurrentUser(current_user, Myp.categories[:joy]).to_json
  end
end
