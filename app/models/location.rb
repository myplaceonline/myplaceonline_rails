# `region` is country, `sub_region1` is state, and `sub_region2` is city.
class Location < ActiveRecord::Base
  belongs_to :owner, class: Identity
  validate :at_least_one
  
  has_many :location_phones, :dependent => :destroy
  accepts_nested_attributes_for :location_phones, allow_destroy: true, reject_if: :all_blank
  
  def at_least_one
    if [name, address1, address2, address3, region, sub_region1, sub_region2].reject(&:blank?).size == 0
      errors.add("", "Name or address required")
    end
  end
  
  def region_name
    if !region.blank?
      Carmen::Country.coded(region).official_name
    else
      nil
    end
  end
  
  def display
    result = Myp.appendstr(nil, name, ", ")
    if name.blank?
      result = Myp.appendstr(result, address1, ", ")
    end
    result = Myp.appendstr(result, sub_region2, ", ")
    result = Myp.appendstr(result, sub_region1, ", ")
    result = Myp.appendstr(result, region, ", ")
    if result.blank?
      result = Myp.appendstr(result, address2, ", ")
    end
    if result.blank?
      result = Myp.appendstr(result, address3, ", ")
    end
    result
  end
  
  # Prefer just name, sub_region2, sub_region1, region
  def display_simple
    result = Myp.appendstr(nil, name, ", ")
    result = Myp.appendstr(result, sub_region2, ", ")
    result = Myp.appendstr(result, sub_region1, ", ")
    result = Myp.appendstr(result, region, ", ")
    if result.blank?
      result = Myp.appendstr(result, address2, ", ")
    end
    if result.blank?
      result = Myp.appendstr(result, address3, ", ")
    end
    if result.blank?
      result = Myp.appendstr(result, address1, ", ")
    end
    result
  end
  
  def display_general_region
    result = ""
    if !sub_region2.blank?
      if !result.blank?
        result += ", "
      end
      result += sub_region2
    end
    if !sub_region1.blank?
      if !result.blank?
        result += ", "
      end
      result += sub_region1
    end
    if result.blank?
      result = name
    end
    if result.blank?
      result = address1
    end
    result
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
    result = Myp.appendstr(nil, name, ", ")
    result = Myp.appendstr(result, address1, ", ")
    result = Myp.appendstr(result, address2, ", ")
    result = Myp.appendstr(result, address3, ", ")
    result = Myp.appendstr(result, sub_region2, ", ")
    result = Myp.appendstr(result, sub_region1_name, ", ")
    result = Myp.appendstr(result, postal_code, " ")
    result = Myp.appendstr(result, region_name, ", ")
    result
  end
  
  def address_one_line_simple
    result = Myp.appendstr(nil, name, ", ")
    result = Myp.appendstr(result, address1, ", ")
    result = Myp.appendstr(result, address2, ", ")
    result = Myp.appendstr(result, address3, ", ")
    result = Myp.appendstr(result, sub_region2, ", ")
    result = Myp.appendstr(result, sub_region1, ", ")
    result = Myp.appendstr(result, postal_code, " ")
    result = Myp.appendstr(result, region, ", ")
    result
  end
  
  def map_url
    result = address_one_line
    if !result.blank?
      result = "https://www.google.com/maps/place/" + ERB::Util.url_encode(result)
    end
    result
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
