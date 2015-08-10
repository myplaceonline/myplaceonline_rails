class SetGunsExplicit < ActiveRecord::Migration
  def change
    category = Category.where(name: "guns").first
    category.explicit = true
    category.save!
  end
end
