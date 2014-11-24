class OrderController < ApplicationController
  def index
    @initialCategoryList = Myp.categoriesForCurrentUser(current_user, Category.find_by_name("order")).to_json
  end
end
