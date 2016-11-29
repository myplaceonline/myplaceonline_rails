class Weight < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :amount, presence: true
  validates :amount_type, presence: true
  validates :measure_date, presence: true
  
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
    result
  end
    
  def self.build(params = nil)
    result = self.dobuild(params)
    result.amount_type = 0
    result.measure_date = User.current_user.date_now
    result
  end
  
  def self.calculate_bmi(weight:, height:)
    result = nil
    
    if height.nil?
      height = Height.where(
        "identity_id = 1 and measurement_date <= ?",
        weight.measure_date
      ).order("measurement_date DESC NULLS LAST").limit(1).first
      if height.nil?
        height = Height.where("identity_id = 1").order("measurement_date DESC NULLS LAST").limit(1).first
      end
    elsif weight.nil?
      weight = Weight.where(
        "identity_id = 1 and measure_date <= ?",
        height.measurement_date
      ).order("measure_date DESC NULLS LAST").limit(1).first
      if weight.nil?
        weight = Weight.where("identity_id = 1").order("measure_date DESC NULLS LAST").limit(1).first
      end
    else
      raise "TODO"
    end
    
    if !weight.nil? && !height.nil?
      case weight.amount_type
      when 0
        # http://www.cdc.gov/healthyweight/assessing/bmi/adult_bmi/index.html
        inches = height.in_inches 
        result = (weight.amount.to_f / (inches * inches).to_f) * 703
      else
        raise "TODO"
      end
    end
    
    result
  end
end
