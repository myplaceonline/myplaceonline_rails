class BloodConcentration < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :concentration_name, presence: true
  
  def display
    result = self.concentration_name
    if self.concentration_minimum.nil? && self.concentration_maximum.nil?
      result = Myp.appendstrwrap(result, Myp.get_select_name(self.concentration_type, Myp::LIQUID_CONCENTRATIONS))
    elsif !self.concentration_minimum.nil? && !self.concentration_maximum.nil?
      result = Myp.appendstrwrap(result, self.concentration_minimum.to_s + " - " + self.concentration_maximum_with_type)
    elsif !self.concentration_minimum.nil?
      result = Myp.appendstrwrap(result, "> " + self.concentration_minimum_with_type)
    else
      result = Myp.appendstrwrap(result, "< " + self.concentration_maximum_with_type)
    end
    result
  end

  def concentration_minimum_with_type
    if self.concentration_minimum.nil?
      nil
    else
      Myp.appendstr(self.concentration_minimum.to_s, Myp.get_select_name(self.concentration_type, Myp::LIQUID_CONCENTRATIONS))
    end
  end
  
  def concentration_maximum_with_type
    if self.concentration_maximum.nil?
      nil
    else
      Myp.appendstr(self.concentration_maximum.to_s, Myp.get_select_name(self.concentration_type, Myp::LIQUID_CONCENTRATIONS))
    end
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :concentration_name,
      :concentration_type,
      :concentration_minimum,
      :concentration_maximum,
      :notes
    ]
  end
end
