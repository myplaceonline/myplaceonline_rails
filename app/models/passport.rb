class Passport < ActiveRecord::Base
  belongs_to :identity
  validates :region, presence: true
  validates :passport_number, presence: true
  
  def display
    region + " (" + passport_number + ")"
  end
  
  has_many :passport_pictures, :dependent => :destroy
  accepts_nested_attributes_for :passport_pictures, allow_destroy: true, reject_if: :all_blank

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
