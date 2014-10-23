class JoyController < MyplaceonlineController
  def index
    @initialCategoryList = categoriesForCurrentUser(Category.find(1)).to_json
  end
end
