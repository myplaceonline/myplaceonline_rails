class GraphController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:display]

  def display
    @sources = Myp.categories.map{|k,v| I18n.t("myplaceonline.category." + v.name) }.sort
  end
end
