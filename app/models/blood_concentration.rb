class BloodConcentration < ActiveRecord::Base
  # concentration_name:string concentration_type:integer 'concentration_minimum:decimal{10,2}' 'concentration_maximum:decimal{10,2}'
  belongs_to :owner, class: Identity
  validates :concentration_name, presence: true
  
  def display
    concentration_name
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :concentration_name,
      :concentration_type,
      :concentration_minimum,
      :concentration_maximum
    ]
  end
end
