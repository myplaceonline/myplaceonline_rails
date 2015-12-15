class CategoryPointsAmount < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :category
end
