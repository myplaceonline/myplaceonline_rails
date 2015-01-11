class AddCategoryCreditScores < ActiveRecord::Migration
  def change
    Category.create(name: "credit_scores", link: "credit_scores", position: 0, parent: Category.find_by_name("order"))
  end
end
