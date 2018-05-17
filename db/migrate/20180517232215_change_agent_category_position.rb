class ChangeAgentCategoryPosition < ActiveRecord::Migration[5.1]
  def change
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      cat = Category.where(name: "agents").take!
      cat.position = 1
      cat.save!
    end
  end
end
