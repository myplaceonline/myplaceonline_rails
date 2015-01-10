class Location < ActiveRecord::Base
  belongs_to :identity
  validates :name, presence: true
  
  has_many :location_phones, :dependent => :destroy
  accepts_nested_attributes_for :location_phones, allow_destroy: true,
      reject_if: proc { |attributes| attributes['number'].blank? }
  
  def region_name
    if !region.nil?
      Carmen::Country.coded(region).official_name
    else
      nil
    end
  end
  
  def display
    name
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
  
  def address_one_line
    result = nil
    result = maybe_append(result, address1)
    result = maybe_append(result, address2)
    result = maybe_append(result, address3)
    result = maybe_append(result, sub_region2)
    result = maybe_append(result, sub_region1)
    result = maybe_append(result, postal_code, " ")
    #result = maybe_append(result, region_name)
    result
  end
  
  def map_url
    result = address_one_line
    if !result.blank?
      result = "https://www.google.com/maps/place/" + ERB::Util.url_encode(result)
    end
    result
  end
  
  def maybe_append(str, val, delimiter = ", ")
    if !val.blank?
      if str.nil?
        str = ""
      end
      if !str.blank?
        str += delimiter
      end
      str += val
    end
    str
  end
end
