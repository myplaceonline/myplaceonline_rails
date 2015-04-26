# 'cashback_percentage:decimal{10,2}' applies_to:string start_date:date end_date:date 'yearly_maximum:decimal{10,2}' notes:text
class Cashback < ActiveRecord::Base
  belongs_to :identity
  
  validates :cashback_percentage, presence: true

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
  
  def self.params
    [
      :id,
      :cashback_percentage,
      :applies_to,
      :start_date,
      :end_date,
      :yearly_maximum,
      :notes,
      :default_cashback
    ]
  end
end
