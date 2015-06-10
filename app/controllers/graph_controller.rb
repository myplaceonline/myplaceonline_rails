class GraphController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:display]

  def display
    @sources = Myp.categories.map{|k,v| I18n.t("myplaceonline.category." + v.name) }.sort
    #@graphdata = "Date,Temperature\n2008-05-07 12:34:56,75\n2008-05-08 12:34:56,70\n2008-05-09 12:34:56,80\n"
  end
end
