class HeartRate < ActiveRecord::Base
  belongs_to :identity
  
  # beats:integer measurement_date:date measurement_source:string

  validates :beats, presence: true
  validates :measurement_date, presence: true
  
  def display
    beats.to_s + " " + I18n.t("myplaceonline.heart_rates.beats")
  end

  before_create :do_before_save
  before_update :do_before_save
  
  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
