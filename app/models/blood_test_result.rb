class BloodTestResult < ActiveRecord::Base
  belongs_to :blood_test

  belongs_to :blood_concentration
  accepts_nested_attributes_for :blood_concentration, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def blood_concentration_attributes=(attributes)
    if !attributes['id'].blank?
      self.blood_concentration = BloodConcentration.find(attributes['id'])
    end
    super
  end

  belongs_to :identity
end
