class MyplaceonlineActiveRecord < ActiveRecord::Base
  self.abstract_class = true
  
  belongs_to :owner, class_name: Identity

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
