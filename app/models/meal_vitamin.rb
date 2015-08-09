class MealVitamin < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :meal

  belongs_to :owner, class_name: Identity
  
  belongs_to :vitamin
  accepts_nested_attributes_for :vitamin, allow_destroy: true, reject_if: :all_blank
  allow_existing :vitamin
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
