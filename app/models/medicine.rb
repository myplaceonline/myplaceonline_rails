class Medicine < ActiveRecord::Base
  belongs_to :owner, class: Identity
  
  validates :medicine_name, presence: true
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
  
  def display
    medicine_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :medicine_name,
      :notes,
      :dosage,
      :dosage_type
    ]
  end
end
