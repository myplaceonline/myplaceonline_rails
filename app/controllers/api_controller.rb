class ApiController < ApplicationController
  def index
  end
  
  def categories
    respond_to do |format|
      format.json { render json: Myp.categoriesForCurrentUser(current_user, nil, true)}
    end
  end
end
