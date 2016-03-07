class EmailToken < ActiveRecord::Base
  belongs_to :identity
end
