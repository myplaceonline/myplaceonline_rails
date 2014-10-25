class MeaningController < MyplaceonlineController
  def index
    @initialCategoryList = categoriesForCurrentUser(Category.find_by_name("meaning")).to_json
  end
end
