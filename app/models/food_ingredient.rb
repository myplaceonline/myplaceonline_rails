class FoodIngredient < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :parent_food, class_name: Food

  belongs_to :owner, class_name: Identity
  
  belongs_to :food
  accepts_nested_attributes_for :food, allow_destroy: true, reject_if: :all_blank
  allow_existing :food
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
