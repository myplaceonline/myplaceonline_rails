class Gun < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :gun_name, presence: true
  
  has_many :gun_registrations, :dependent => :destroy
  accepts_nested_attributes_for :gun_registrations, allow_destroy: true, reject_if: :all_blank

  def display
    gun_name
  end
end
