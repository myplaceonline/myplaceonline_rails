class Job < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :job_title, presence: true
  
  def display
    result = job_title
    if !company.nil?
      result += " @ " + company.display
    end
    result
  end
  
  child_property(name: :company)

  child_property(name: :manager_contact, model: Contact)

  child_properties(name: :job_salaries, sort: "started DESC")

  child_property(name: :internal_address, model: Location)

  child_properties(name: :job_managers)

  child_properties(name: :job_reviews, sort: "review_date DESC")

  child_properties(name: :job_myreferences)

  child_properties(name: :job_accomplishments, sort: "accomplishment_time DESC")

  child_files
  
  def days_vacation_calculated
    if self.work_time_percentage.nil?
      return self.days_vacation
    else
      return (self.days_vacation*(self.work_time_percentage/100.0))
    end
  end
  
  def salary
    if self.job_salaries.count > 0
      return self.job_salaries[0]
    else
      return nil
    end
  end
end
