class Notepad < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  def display
    title
  end
end
