class CreditReport < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :credit_report_date, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :credit_report_description, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :annual_free_report, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :credit_reporting_agency, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :credit_report_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  AGENCY_EQUIFAX = 0
  AGENCY_EXPERIAN = 1
  AGENCY_TRANSUNION = 2
  AGENCY_OTHER = 3

  AGENCIES = [
    ["myplaceonline.credit_reports.agencies.equifax", AGENCY_EQUIFAX],
    ["myplaceonline.credit_reports.agencies.experian", AGENCY_EXPERIAN],
    ["myplaceonline.credit_reports.agencies.transunion", AGENCY_TRANSUNION],
    ["myplaceonline.credit_reports.agencies.other", AGENCY_OTHER],
  ]

  validates :credit_report_date, presence: true
  validates :credit_reporting_agency, presence: true
  
  def display
    Myp.appendstrwrap(Myp.get_select_name(self.credit_reporting_agency, AGENCIES), Myp.display_date(self.credit_report_date, User.current_user))
  end

  child_files

  def self.build(params = nil)
    result = self.dobuild(params)
    result.credit_report_date = User.current_user.date_now
    result
  end
end
