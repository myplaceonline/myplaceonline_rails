class RetirementPlanAmount < ActiveRecord::Base
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

  has_many :retirement_plan_amount_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :retirement_plan_amount_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :retirement_plan_amount_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(retirement_plan_amount_files, [I18n.t("myplaceonline.category.retirement_plans"), retirement_plan.display])
  end
end
