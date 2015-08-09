class Food < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
  
  validates :food_name, presence: true
  
  has_many :food_ingredients, :foreign_key => 'parent_food_id'
  accepts_nested_attributes_for :food_ingredients, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :food_ingredients, [{:name => :food}]

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
      :weight,
      :weight_type,
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
          :weight,
          :weight_type
        ]
      ]
    ]
  end
end
