class RandomController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:activity]
  
  def index
  end

  def activity
  end
end
