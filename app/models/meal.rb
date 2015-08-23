class Meal < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :meal_time, presence: true
  
  belongs_to :location, :autosave => true
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }

  has_many :meal_foods, :dependent => :destroy
  accepts_nested_attributes_for :meal_foods, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :meal_foods, [{:name => :food}]

  has_many :meal_drinks, :dependent => :destroy
  accepts_nested_attributes_for :meal_drinks, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :meal_drinks, [{:name => :drink}]

  has_many :meal_vitamins, :dependent => :destroy
  accepts_nested_attributes_for :meal_vitamins, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :meal_vitamins, [{:name => :vitamin}]
  
  def display
    Myp.display_datetime_short(meal_time, User.current_user)
  end

  def self.build(params = nil)
    result = super(params)
    result.meal_time = DateTime.now
    result
  end
end
