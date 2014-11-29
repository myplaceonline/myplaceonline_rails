class MeaningController < ApplicationController
  skip_authorization_check

  def index
    @initialCategoryList = Myp.categoriesForCurrentUser(current_user, Myp.categories[:meaning]).to_json
  end
end
