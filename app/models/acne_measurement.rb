class AcneMeasurement < MyplaceonlineIdentityRecord
  validates :measurement_datetime, presence: true
  
  has_many :acne_measurement_pictures, :dependent => :destroy
  accepts_nested_attributes_for :acne_measurement_pictures, allow_destroy: true, reject_if: :all_blank

  def display
    result = ""
    if !new_pimples.nil?
      result += new_pimples.to_s + " " + I18n.t("myplaceonline.acne_measurements.new_pimples")
    elsif !total_pimples.nil?
      result += total_pimples.to_s + " " + I18n.t("myplaceonline.acne_measurements.total_pimples")
    end
    result += " (" + Myp.display_datetime(measurement_datetime, User.current_user) + ")"
    result
  end
end
