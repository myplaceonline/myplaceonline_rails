class MedicineUsage < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
  validates :usage_time, presence: true
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end

  has_many :medicine_usage_medicines, :dependent => :destroy
  accepts_nested_attributes_for :medicine_usage_medicines, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :medicine_usage_medicines, [{:name => :medicine}]
  
  def display
    Myp.display_datetime_short(usage_time, User.current_user)
  end
end
