class MeaningController < ApplicationController
  def index
    @initialCategoryList = Myp.categoriesForCurrentUser(current_user, Category.find_by_name("meaning")).to_json
  end
end
