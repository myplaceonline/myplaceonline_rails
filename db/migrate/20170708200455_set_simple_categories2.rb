class SetSimpleCategories2 < ActiveRecord::Migration[5.1]
  def change
    ["health", "obscure", "random", "tools"].each do |name|
      c = Category.where(name: name).take!
      c.simple = true
      c.save!
    end
  end
end
