class MakeUsersCategoryExperimental < ActiveRecord::Migration
  def change
    c = Category.where(name: "users").take!
    c.experimental = true
    c.save!
  end
end
