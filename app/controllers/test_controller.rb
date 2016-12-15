class TestController < ApplicationController
  skip_before_action :do_authenticate_user
  skip_authorization_check
  
  def index; end
  def test1; end
    
  def throw
    raise "Random Exception"
  end
  
  def hello_world
    render json: {
      :test => "Hello World"
    }
  end
end
