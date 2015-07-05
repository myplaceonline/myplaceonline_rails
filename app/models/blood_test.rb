class BloodTest < ActiveRecord::Base
  belongs_to :owner, class: Identity
  validates :fast_started, presence: true
  
  def display
    Myp.display_datetime_short(fast_started, User.current_user)
  end
  
  has_many :blood_test_results, :dependent => :destroy
  accepts_nested_attributes_for :blood_test_results, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def blood_test_results_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['blood_concentration_attributes'].blank? && !value['blood_concentration_attributes']['id'].blank? && value['_destroy'] != "1"
        self.blood_test_results.each{|x|
          if x.blood_concentration.id == value['blood_concentration_attributes']['id'].to_i
            x.blood_concentration = BloodConcentration.find(value['blood_concentration_attributes']['id'])
          end
        }
      end
    }
  end

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
