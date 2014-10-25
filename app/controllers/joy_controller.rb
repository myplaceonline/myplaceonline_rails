class JoyController < MyplaceonlineController
  def index
    @initialCategoryList = categoriesForCurrentUser(Category.find_by_name("joy")).to_json
  end
end
