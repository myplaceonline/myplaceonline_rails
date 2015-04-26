class MealDrink < ActiveRecord::Base
  belongs_to :meal

  belongs_to :identity
  
  belongs_to :drink, :dependent => :destroy
  accepts_nested_attributes_for :drink, allow_destroy: true, reject_if: :all_blank
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
