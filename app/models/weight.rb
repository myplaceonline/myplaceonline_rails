class Weight < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :amount, presence: true
  validates :amount_type, presence: true
  validates :measure_date, presence: true
  
  BSA_FORMULA_DUBOIS = 0
  
  def display
    result = amount.to_s
    if amount_type == 0
      result += " lb"
    end
    result = Myp.appendstrwrap(result, Myp.display_date(measure_date, User.current_user))
    bmi = Weight.calculate_bmi(weight: self, height: nil)
    if !bmi.nil?
      result = Myp.appendstrwrap(result, I18n.t("myplaceonline.weights.bmi") + " #{sprintf("%0.02f", bmi)}")
    end
    bsa = Weight.calculate_bsa(weight: self, height: nil)
    if !bsa.nil?
      result = Myp.appendstrwrap(result, I18n.t("myplaceonline.weights.bsa") + " #{sprintf("%0.02f", bsa)}")
    end
    result
  end
    
  def self.build(params = nil)
    result = self.dobuild(params)
    result.amount_type = 0
    result.measure_date = User.current_user.date_now
    result
  end
  
  def in_pounds
    case self.amount_type
    when 0
      self.amount
    else
      raise "TODO"
    end
  end
  
  def in_kg
    case self.amount_type
    when 0
      self.amount / 2.2
    else
      raise "TODO"
    end
  end
  
  def self.near_height(height:)
    result = Weight.where(
      "identity_id = 1 and measure_date <= ?",
      height.measurement_date
    ).order("measure_date DESC NULLS LAST").limit(1).first
    if result.nil?
      result = Weight.where("identity_id = 1").order("measure_date DESC NULLS LAST").limit(1).first
    end
    result
  end
  
  def self.calculate_bmi(weight:, height:)
    result = nil
    
    if height.nil?
      height = Height.near_weight(weight: weight)
    elsif weight.nil?
      weight = Weight.near_height(height: height)
    else
      raise "TODO"
    end
    
    if !weight.nil? && !height.nil?
      # https://en.wikipedia.org/wiki/Body_mass_index#History_and_usage_in_obesity_studies
      result = (weight.in_pounds / (height.in_inches ** 2)) * 703
    end
    
    result
  end
  
  def self.calculate_bsa(weight:, height:, formula: Weight::BSA_FORMULA_DUBOIS)
    result = nil
    
    if height.nil?
      height = Height.near_weight(weight: weight)
    elsif weight.nil?
      weight = Weight.near_height(height: height)
    else
      raise "TODO"
    end
    
    if !weight.nil? && !height.nil?
      # https://en.wikipedia.org/wiki/Body_surface_area#Calculation
      case formula
      when Weight::BSA_FORMULA_DUBOIS
        result = 0.007184 * (weight.in_kg ** 0.425) * (height.in_cm ** 0.725)
      else
        raise "TODO"
      end
    end
    
    result
  end
end
