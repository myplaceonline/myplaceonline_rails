class Website < ActiveRecord::Base
  belongs_to :identity
  validates :url, presence: true
  
  def display
    title
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
