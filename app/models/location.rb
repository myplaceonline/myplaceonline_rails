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

  def sub_region1_name
    if !region.blank? && !sub_region1.blank?
      reg = Carmen::Country.coded(region)
      if reg.subregions.length > 0
        subregion = reg.subregions.coded(sub_region1)
        if !subregion.nil?
          subregion.name
        else
          sub_region1
        end
      else
        sub_region1
      end
    else
      nil
    end
  end
end
