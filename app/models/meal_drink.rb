class MealDrink < ActiveRecord::Base
  belongs_to :meal

  belongs_to :identity
  
  belongs_to :drink
  accepts_nested_attributes_for :drink, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def drink_attributes=(attributes)
    if !attributes['id'].blank?
      self.drink = Drink.find(attributes['id'])
    end
    super
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
