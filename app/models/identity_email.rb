class IdentityEmail < ActiveRecord::Base
  belongs_to :ref, class: Identity
end
