class SetExplicitCategories < ActiveRecord::Migration
  def change
    c = Category.where(name: "guns").first
    c.explicit = true
    c.save!
  end
end
