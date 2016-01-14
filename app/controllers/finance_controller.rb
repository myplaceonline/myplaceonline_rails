class FinanceController < ApplicationController
  skip_authorization_check

  def index
    @initialCategoryList = Myp.categories_for_current_user(current_user, Myp.categories(User.current_user)[:finance])
  end
end
