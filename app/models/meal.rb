class Meal < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
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
end
