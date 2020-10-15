class GasStation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)

  def display
    result = location.display
    if !self.detour_time.blank? && !self.detour_from.blank?
      result = Myp.appendstrwrap(result, "#{self.detour_time} from #{self.detour_from}")
    end
    return result
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.gas = true
    result
  end

  def self.skip_check_attributes
    ["gas", "diesel", "propane_fillup", "propane_replacement"]
  end

  def self.category_split_button_link
    Rails.application.routes.url_helpers.send("#{self.table_name}_map_path")
  end
  
  def self.category_split_button_title
    I18n.t("myplaceonline.general.map")
  end

  def self.category_split_button_icon
    "navigation"
  end
end
