class IdentityPhone < ActiveRecord::Base
  belongs_to :ref, class: Identity
end
