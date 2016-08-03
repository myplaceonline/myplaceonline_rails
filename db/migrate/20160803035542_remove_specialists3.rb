class RemoveSpecialists3 < ActiveRecord::Migration
  def change
    cat = Category.where(name: "specialists").take!
    CategoryPointsAmount.destroy_all(category: cat)
    cat.destroy!
  end
end
