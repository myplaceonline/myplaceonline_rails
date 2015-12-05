class ChangeCategorySubscriptions < ActiveRecord::Migration
  def change
    cat = Category.where(name: "subscriptions").take!
    cat.name = "memberships"
    cat.link = "memberships"
    cat.additional_filtertext = "subscriptions"
    cat.save!
  end
end
