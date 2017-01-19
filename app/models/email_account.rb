class EmailAccount < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  child_property(name: :password)

  def display
    password.display
  end
end
