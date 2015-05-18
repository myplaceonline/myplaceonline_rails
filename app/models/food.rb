class Food < ActiveRecord::Base
  belongs_to :identity
  
  validates :food_name, presence: true
  
  has_many :food_ingredients, :foreign_key => 'parent_food_id'
  accepts_nested_attributes_for :food_ingredients, allow_destroy: true, reject_if: :all_blank

  # http://stackoverflow.com/a/12064875/4135310
  def food_ingredients_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['food_attributes'].blank? && !value['food_attributes']['id'].blank? && value['_destroy'] != "1"
        self.food_ingredients.each{|x|
          if x.food.id == value['food_attributes']['id'].to_i
            x.food = Food.find(value['food_attributes']['id'])
          end
        }
      end
    }
  end

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
  
  def display
    food_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :food_name,
      :notes,
      :calories,
      :price,
      :food_servings,
      food_ingredients_attributes: [
        :id,
        :_destroy,
        food_attributes: [
          :id,
          :_destroy,
          :food_name,
          :notes,
          :calories,
          :price,
          :food_servings
        ]
      ]
    ]
  end
end
