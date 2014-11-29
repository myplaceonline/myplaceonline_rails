class OrderController < ApplicationController
  skip_authorization_check

  def index
    @initialCategoryList = Myp.categoriesForCurrentUser(current_user, Myp.categories[:order]).to_json
  end
end
