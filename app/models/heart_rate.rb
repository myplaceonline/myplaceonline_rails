class HeartRate < MyplaceonlineIdentityRecord
  validates :beats, presence: true
  validates :measurement_date, presence: true
  
  def display
    beats.to_s + " " + I18n.t("myplaceonline.heart_rates.beats") + " (" + Myp.display_date(measurement_date, User.current_user) + ")"
  end
end
