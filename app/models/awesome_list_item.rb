class AwesomeListItem < ApplicationRecord
  belongs_to :identity
  belongs_to :awesome_list
end
