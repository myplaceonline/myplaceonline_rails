class RetirementPlanAmount < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :retirement_plan
  validates :input_date, presence: true
  validates :amount, presence: true
  
  def display
    Myp.appendstrwrap(Myp.display_currency(amount, User.current_user), Myp.display_date(input_date, User.current_user))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.input_date = User.current_user.date_now
    result
  end

  child_properties(name: :retirement_plan_amount_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(retirement_plan_amount_files, [I18n.t("myplaceonline.category.retirement_plans"), retirement_plan.display])
  end
end
