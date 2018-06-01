class ToolsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:gps, :urlencode]
  
  def index
  end

  def gps
  end
  
  def urlencode
    @toencode = params[:toencode]
    @encoded = ""
    if !@toencode.blank?
      @encoded = URI.encode(@toencode, /\W/)
    end
  end
end
