class Location < ActiveRecord::Base
  belongs_to :identity
  validates :name, presence: true
  
  def region_name
    if !region.nil?
      Carmen::Country.coded(region).official_name
    else
      nil
    end
  end
end
