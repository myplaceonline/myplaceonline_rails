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
        self.meal_foods.each{|x|
          if x.food.id == value['food_attributes']['id'].to_i
            x.food = Food.find(value['food_attributes']['id'])
          end
        }
      end
    }
  end

  has_many :meal_drinks, :dependent => :destroy
  accepts_nested_attributes_for :meal_drinks, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def meal_drinks_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['drink_attributes'].blank? && !value['drink_attributes']['id'].blank? && value['_destroy'] != "1"
        self.meal_drinks.each{|x|
          if x.drink.id == value['drink_attributes']['id'].to_i
            x.drink = Drink.find(value['drink_attributes']['id'])
          end
        }
      end
    }
  end

  has_many :meal_vitamins, :dependent => :destroy
  accepts_nested_attributes_for :meal_vitamins, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def meal_vitamins_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['vitamin_attributes'].blank? && !value['vitamin_attributes']['id'].blank? && value['_destroy'] != "1"
        self.meal_vitamins.each{|x|
          if x.vitamin.id == value['vitamin_attributes']['id'].to_i
            x.vitamin = Vitamin.find(value['vitamin_attributes']['id'])
          end
        }
      end
    }
  end
end
