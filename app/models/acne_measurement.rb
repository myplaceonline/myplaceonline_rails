class AcneMeasurement < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :measurement_datetime, presence: true
  
  child_pictures

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
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.measurement_datetime = DateTime.now
    result
  end
end
