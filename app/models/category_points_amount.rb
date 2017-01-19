class CategoryPointsAmount < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :category
end
