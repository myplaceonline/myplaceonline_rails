class CategoryPointsAmount < ActiveRecord::Base
  belongs_to :identity
  belongs_to :category
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
