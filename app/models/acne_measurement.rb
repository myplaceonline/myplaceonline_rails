class AcneMeasurement < ActiveRecord::Base
  belongs_to :identity
  
  validates :measurement_datetime, presence: true
  
  def display
    result = ""
    if !total_pimples.nil?
      result += total_pimples.to_s
    end
    result += " (" + Myp.display_datetime(measurement_datetime, User.current_user) + ")"
    result
  end

  before_create :do_before_save
  before_update :do_before_save
  
  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
