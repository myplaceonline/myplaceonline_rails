class ApiController < ApplicationController

  @@DEFAULT_PASSWORD_LENGTH = 16  
  @@POSSIBILITIES_ALPHANUMERIC = [('0'..'9'), ('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
  @@POSSIBILITIES_ALPHANUMERIC_PLUS_SPECIAL = [('0'..'9'), ('a'..'z'), ('A'..'Z'), ['_', '-', '!']].map { |i| i.to_a }.flatten
  
  skip_authorization_check
  
  def index
  end
  
  def categories
    respond_to do |format|
      format.json { render json: Myp.categories_for_current_user(current_user, nil, true)}
    end
  end
  
  def randomString
    length = @@DEFAULT_PASSWORD_LENGTH
    if !params[:length].nil?
      length = params[:length].to_i
      if length < 0 || length > 512
        @@DEFAULT_PASSWORD_LENGTH
      end
    end
    possibilities = @@POSSIBILITIES_ALPHANUMERIC_PLUS_SPECIAL
    result = (0...length).map { possibilities[SecureRandom.random_number(possibilities.length)] }.join
    render json: {
      :randomString => result
    }
  end
end
