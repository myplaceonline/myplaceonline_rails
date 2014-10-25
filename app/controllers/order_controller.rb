class OrderController < MyplaceonlineController
  def index
    @initialCategoryList = categoriesForCurrentUser(Category.find_by_name("order")).to_json
  end
end
