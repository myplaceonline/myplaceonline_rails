class PointsController < ApplicationController

  skip_authorization_check
  
  def show
    @totalPoints = current_user.total_points
  end
end
