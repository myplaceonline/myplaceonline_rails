class SetCategoryFilter < ActiveRecord::Migration
  def change
    c = Category.where(name: "meals").first
    c.additional_filtertext = "snacks"
    c.save!
  end
end
