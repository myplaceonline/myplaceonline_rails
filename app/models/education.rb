class Education < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  EDUCATION_TYPES = [
    ["myplaceonline.educations.education_type_high_school", 0],
    ["myplaceonline.educations.education_type_ged", 1],
    ["myplaceonline.educations.education_type_associate_art", 2],
    ["myplaceonline.educations.education_type_associate_science", 3],
    ["myplaceonline.educations.education_type_associate_applied_science", 4],
    ["myplaceonline.educations.education_type_bachelors_art", 5],
    ["myplaceonline.educations.education_type_bachelors_fine_art", 6],
    ["myplaceonline.educations.education_type_bachelors_laws", 7],
    ["myplaceonline.educations.education_type_bachelors_science", 8],
    ["myplaceonline.educations.education_type_bachelors_applied_science", 9],
    ["myplaceonline.educations.education_type_masters_art", 10],
    ["myplaceonline.educations.education_type_masters_fine_art", 11],
    ["myplaceonline.educations.education_type_masters_ba", 12],
    ["myplaceonline.educations.education_type_masters_science", 13],
    ["myplaceonline.educations.education_type_doctor_education", 14],
    ["myplaceonline.educations.education_type_doctor_jd", 15],
    ["myplaceonline.educations.education_type_doctor_medicine", 16],
    ["myplaceonline.educations.education_type_doctor_philosophy", 17]
  ]

  validates :education_name, presence: true
  #validates :education_end, presence: true
  
  child_property(name: :location)
  
  attr_accessor :is_graduated
  boolean_time_transfer :is_graduated, :graduated
  
  def display
    Myp.appendstrwrap(Myp.appendstrwrap(education_name, degree_name), Education.education_type_abbreviation(self.degree_type))
  end

  child_files
  
  def self.education_type_abbreviation(education_type)
    if !education_type.nil?
      I18n.t(Education::EDUCATION_TYPES[education_type][0].gsub("education_type_", "education_type_abbreviation_"))
    else
      nil
    end
  end

  def self.skip_check_attributes
    ["is_graduated"]
  end
end
