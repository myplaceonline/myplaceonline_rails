class MedicineUsage < ActiveRecord::Base
  belongs_to :identity
  validates :usage_time, presence: true
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end

  has_many :medicine_usage_medicines, :dependent => :destroy
  accepts_nested_attributes_for :medicine_usage_medicines, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def medicine_usage_medicines_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['medicine_attributes'].blank? && !value['medicine_attributes']['id'].blank? && value['_destroy'] != "1"
        self.medicine_usage_medicines.each{|x|
          if x.medicine.id == value['medicine_attributes']['id'].to_i
            x.medicine = Medicine.find(value['medicine_attributes']['id'])
          end
        }
      end
    }
  end
  
  def display
    Myp.display_datetime_short(usage_time, User.current_user)
  end
end
