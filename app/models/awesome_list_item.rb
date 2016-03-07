class AwesomeListItem < ActiveRecord::Base
  belongs_to :identity
  belongs_to :awesome_list
end
