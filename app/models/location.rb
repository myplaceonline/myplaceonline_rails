require 'googlemaps/services/client'
require 'googlemaps/services/directions'
include GoogleMaps::Services

# `region` is country, `sub_region1` is state, and `sub_region2` is city.
class Location < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :address1, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :address2, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :address3, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :region, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :sub_region1, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :sub_region2, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :postal_code, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :latitude, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :longitude, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :location_phones, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
      { name: :location_pictures, type: ApplicationRecord::PROPERTY_TYPE_FILES },
      { name: :website, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end
  
  validate :at_least_one
  
  child_properties(name: :location_phones)
  
  child_property(name: :website)
  
  # https://github.com/alexreisner/geocoder
  geocoded_by :geocode_address
  #reverse_geocoded_by :latitude, :longitude
  
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
  
  def region_short_name
    if !region.blank?
      Carmen::Country.coded(region).code
    else
      nil
    end
  end
  
  child_pictures

  def display(use_full_region_name: false)
    result = Myp.appendstr(nil, name, ", ")
    result = Myp.appendstr(result, address1, ", ")
    result = Myp.appendstr(result, sub_region2, ", ")
    result = Myp.appendstr(result, sub_region1, ", ")
    # If all we have is a region but we have lat/long,
    # then use that and assume the region is indeterminate
    if result.blank? && address2.blank? && address3.blank? && !latitude.blank? && !longitude.blank?
      result = latitude.to_s + "," + longitude.to_s
    else
      if result.blank?
        result = Myp.appendstr(result, address2, ", ")
      end
      if result.blank?
        result = Myp.appendstr(result, address3, ", ")
      end
      if result.blank? || region != "US"
        result = Myp.appendstr(result, use_full_region_name ? region_name : region, ", ")
      end
    end
    result
  end
  
  # Prefer just name, sub_region2, sub_region1, region
  def display_simple
    result = Myp.appendstr(nil, name, ", ")
    result = Myp.appendstr(result, sub_region2, ", ")
    result = Myp.appendstr(result, sub_region1, ", ")
    if result.blank? || region != "US"
      result = Myp.appendstr(result, region, ", ")
    end
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
  
  def display_really_simple
    result = Myp.appendstr(nil, name, ", ")
    result = Myp.appendstr(result, address1, ", ")
    result = Myp.appendstr(result, address2, ", ")
    result = Myp.appendstr(result, address3, ", ")
    result
  end
  
  def display_address_lines
    result = Myp.appendstr(nil, address1)
    result = Myp.appendstr(result, address2, ", ")
    result = Myp.appendstr(result, address3, ", ")
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
  
  def sub_region1_short_name
    if !region.blank? && !sub_region1.blank?
      reg = Carmen::Country.coded(region)
      if reg.subregions.length > 0
        subregion = reg.subregions.coded(sub_region1)
        if !subregion.nil?
          subregion.code
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
  
  def geocode_address
    address_one_line(false, address_details: false)
  end
  
  def address_one_line(usename = true, address_details: true)
    result = nil
    if usename
      result = Myp.appendstr(result, name, ", ")
    end
    result = Myp.appendstr(result, address1, ", ")
    if address_details
      result = Myp.appendstr(result, address2, ", ")
      result = Myp.appendstr(result, address3, ", ")
    end
    result = Myp.appendstr(result, sub_region2, ", ")
    result = Myp.appendstr(result, sub_region1_short_name, ", ")
    result = Myp.appendstr(result, postal_code, " ")
    if result.blank? || region != "US"
      result = Myp.appendstr(result, region_short_name, ", ")
    end
    result
  end
  
  def address_one_line_simple
    result = nil
    result = Myp.appendstr(result, name, ", ")
    result = Myp.appendstr(result, address1, ", ")
    result = Myp.appendstr(result, address2, ", ")
    result = Myp.appendstr(result, address3, ", ")
    result = Myp.appendstr(result, sub_region2, ", ")
    result = Myp.appendstr(result, sub_region1_short_name, ", ")
    result = Myp.appendstr(result, postal_code, " ")
    if result.blank? || region != "US"
      result = Myp.appendstr(result, region_short_name, ", ")
    end
    result
  end
  
  def map_url
    result = self.map_link_component
    if !result.blank?
      result = "https://www.google.com/maps/place/" + ERB::Util.url_encode(result)
    end
    result
  end
  
  def map_link_component
    if !latitude.blank? && !longitude.blank?
      result = latitude.to_s + "," + longitude.to_s
    else
      result = address_one_line(false, address_details: false)
    end
  end
  
  def map_directions_url(source_location: nil, destination_location: nil)
    result = self.map_link_component
    if !result.blank?
      if !source_location.nil?
        result = "https://www.google.com/maps/dir/" + ERB::Util.url_encode(source_location.map_link_component) + "/" + ERB::Util.url_encode(result)
      elsif !destination_location.nil?
        result = "https://www.google.com/maps/dir/" + ERB::Util.url_encode(result) + "/" + ERB::Util.url_encode(destination_location.map_link_component)
      else
        result = nil
      end
    end
    result
  end
  
  def display_city
    result = sub_region2
    result = Myp.alternative_if_blank(result, name)
    result = Myp.alternative_if_blank(result, address1)
    result = Myp.alternative_if_blank(result, address2)
    result = Myp.alternative_if_blank(result, address3)
    result = Myp.alternative_if_blank(result, sub_region1_short_name)
    result = Myp.alternative_if_blank(result, postal_code)
    result = Myp.alternative_if_blank(result, region_name)
    result
  end
  
  def self.sorts
    %{
       CASE
        WHEN locations.name IS NOT NULL THEN locations.name
        WHEN locations.address1 IS NOT NULL THEN locations.address1
        WHEN locations.address2 IS NOT NULL THEN locations.address2
        WHEN locations.address3 IS NOT NULL THEN locations.address3
        WHEN locations.sub_region2 IS NOT NULL THEN locations.sub_region2
        WHEN locations.sub_region1 IS NOT NULL THEN locations.sub_region1
        ELSE locations.region
       END ASC
    }
  end

  def self.skip_check_attributes
    ["region"]
  end
  
  def ensure_gps
    if self.latitude.nil? && self.current_user_owns?
      self.geocode
      self.save!
    end
    return !self.latitude.nil?
  end
  
  def estimate_driving_time
    if self.time_from_home.nil? && self.current_user_owns?
      location = User.current_user.current_identity.primary_location
      if !location.nil?
        client = GoogleClient.new(key: ENV["GOOGLE_MAPS_API_SERVER_KEY"], response_format: :json, read_timeout: 5)
        # https://developers.google.com/maps/documentation/directions/intro
        directions = Directions.new(client)
        result = directions.query(
          origin: location.map_link_component,
          destination: self.map_link_component,
          mode: "driving",
          departure_time: Time.now,
          alternatives: false
        )
        # "For routes that contain no waypoints, the route will consist of a single "leg,""
        # https://developers.google.com/maps/documentation/directions/intro#Legs
        duration = result[0]["legs"][0]["duration_in_traffic"]
        if duration.nil?
          duration = result[0]["legs"][0]["duration"]
        end
        # value indicates the duration in seconds.
        self.time_from_home = duration["value"]
        self.save!
      end
    end
    return !self.time_from_home.nil?
  end
end
