class BloodTest < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :fast_started, presence: true
  
  def display
    Myp.display_datetime_short(fast_started, User.current_user)
  end
  
  has_many :blood_test_results, :dependent => :destroy
  accepts_nested_attributes_for :blood_test_results, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :blood_test_results, [{:name => :blood_concentration}]
end
