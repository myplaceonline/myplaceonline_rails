class InfoController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check
  
  def index; end
  def contact; end
  def credits; end
  def diagnostics; end
end
