class AcneMeasurement < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :measurement_datetime, presence: true
  
  has_many :acne_measurement_pictures, :dependent => :destroy
  accepts_nested_attributes_for :acne_measurement_pictures, allow_destroy: true, reject_if: :all_blank

  before_validation :update_pic_folders
  
  def update_pic_folders
    put_pictures_in_folder(acne_measurement_pictures, [I18n.t("myplaceonline.category.acne_measurements"), display])
  end

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
