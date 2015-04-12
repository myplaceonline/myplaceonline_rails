class TestController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check
  
  def index; end
  def test1; end
end
