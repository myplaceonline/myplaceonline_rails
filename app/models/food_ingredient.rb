class FoodIngredient < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :parent_food, class_name: Food

  child_property(name: :food)
end
