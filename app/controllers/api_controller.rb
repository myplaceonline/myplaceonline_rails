class ApiController < ApplicationController

  skip_authorization_check
  
  def index
  end
  
  def categories
    respond_to do |format|
      format.json { render json: Myp.categories_for_current_user(current_user, nil, true)}
    end
  end
  
  def randomString
    length = Myp.default_password_length
    if !params[:length].nil?
      length = params[:length].to_i
      if length <= 0 || length > 512
        length = Myp.default_password_length
      end
    end
    possibilities = Myp.password_possibilities_alphanumeric_plus_special
    result = (0...length).map { possibilities[SecureRandom.random_number(possibilities.length)] }.join
    render json: {
      :randomString => result
    }
  end
  
  def subregions
    render partial: 'myplaceonline/subregionselect'
  end
end
