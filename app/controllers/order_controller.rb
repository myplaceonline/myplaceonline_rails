class OrderController < ApplicationController
  def index
    @initialCategoryList = Myp.categoriesForCurrentUser(current_user, Myp.categories[:order]).to_json
  end
end
