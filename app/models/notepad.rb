class Notepad < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern

  attr_accessor :is_archived
  boolean_time_transfer :is_archived, :archived

  def display
    Myp.appendstrwrap(title, !archived.nil? ? I18n.t("myplaceonline.general.archived") : nil)
  end
end
