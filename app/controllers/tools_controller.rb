class ToolsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:gps, :urlencode, :urldecode]
  
  def index
  end

  def gps
  end
  
  def urlencode
    @toencode = params[:toencode]
    @encoded = ""
    if !@toencode.blank?
      @encoded = CGI.escape(@toencode)
    end
  end
  
  def urldecode
    @todecode = params[:todecode]
    @decoded = ""
    if !@todecode.blank?
      @decoded = CGI.unescape(@todecode)
    end
  end
end
