class Meal < ActiveRecord::Base
  belongs_to :identity
  validates :meal_time, presence: true
  
  belongs_to :location, :autosave => true
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end

  has_many :meal_foods, :dependent => :destroy
  accepts_nested_attributes_for :meal_foods, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def meal_foods_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['food_attributes'].blank? && !value['food_attributes']['id'].blank? && value['_destroy'] != "1"
        self.meal_foods.each{|mf|
          if mf.food.id == value['food_attributes']['id'].to_i
            mf.food = Food.find(value['food_attributes']['id'])
          end
        }
      end
    }
  end

  has_many :meal_drinks, :dependent => :destroy
  accepts_nested_attributes_for :meal_drinks, allow_destroy: true, reject_if: :all_blank
end
