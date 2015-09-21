class ToolsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:gps]
  
  def index
  end

  def gps
  end
end
