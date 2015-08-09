class BloodTest < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
  validates :fast_started, presence: true
  
  def display
    Myp.display_datetime_short(fast_started, User.current_user)
  end
  
  has_many :blood_test_results, :dependent => :destroy
  accepts_nested_attributes_for :blood_test_results, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :blood_test_results, [{:name => :blood_concentration}]

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
