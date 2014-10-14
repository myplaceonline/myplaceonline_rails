class CategoryPointsAmount < ActiveRecord::Base
  belongs_to :identity
  belongs_to :category
end
