class Contact < ActiveRecord::Base
  belongs_to :ref
  belongs_to :identity
  
  def name
    "Some Contact"
  end
end
