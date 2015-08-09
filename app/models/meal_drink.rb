class MealDrink < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :meal

  belongs_to :owner, class_name: Identity
  
  belongs_to :drink
  accepts_nested_attributes_for :drink, allow_destroy: true, reject_if: :all_blank
  allow_existing :drink
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
