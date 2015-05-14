class VitaminIngredient < ActiveRecord::Base
  belongs_to :parent_food, class_name: Food

  belongs_to :identity
  
  belongs_to :vitamin
  accepts_nested_attributes_for :vitamin, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def food_attributes=(attributes)
    if !attributes['id'].blank?
      self.vitamin = Vitamin.find(attributes['id'])
    end
    super
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
