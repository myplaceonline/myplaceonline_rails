class Notepad < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern

  def display
    Myp.appendstrwrap(title, !archived.nil? ? I18n.t("myplaceonline.general.archived") : nil)
  end
end
