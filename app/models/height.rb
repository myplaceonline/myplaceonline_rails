class Height < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :height_amount, presence: true
  validates :amount_type, presence: true
  validates :measurement_date, presence: true
  
  def display
    result = ""
    if amount_type == 0
      result += (height_amount / 12).floor.to_s + " feet"
      inches = (height_amount % 12)
      inches = (inches * 10**2).round.to_f / 10**2
      if inches > 0
        result += ", " + inches.to_s.gsub("\.0", "") + " inches"
      end
    end
    result = Myp.appendstrwrap(result, Myp.display_date(measurement_date, User.current_user))
    bmi = Weight.calculate_bmi(weight: nil, height: self)
    if !bmi.nil?
      result = Myp.appendstrwrap(result, I18n.t("myplaceonline.weights.bmi") + " #{sprintf("%0.02f", bmi)}")
    end
    bsa = Weight.calculate_bsa(weight: nil, height: self)
    if !bsa.nil?
      result = Myp.appendstrwrap(result, I18n.t("myplaceonline.weights.bsa") + " #{sprintf("%0.02f", bsa)}")
    end
    result
  end
  
  def in_inches
    case self.amount_type
    when 0
      self.height_amount
    else
      raise "TODO"
    end
  end
    
  def in_cm
    case self.amount_type
    when 0
      self.height_amount * 2.54
    else
      raise "TODO"
    end
  end
    
  def build(params = nil)
    result = self.dobuild(params)
    result.amount_type = 0
    result.measurement_date = Date.today
    result
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.measurement_date = User.current_user.date_now
    result
  end

  def self.near_weight(weight:)
    result = Height.where(
      "identity_id = 1 and measurement_date <= ?",
      weight.measure_date
    ).order("measurement_date DESC NULLS LAST").limit(1).first
    if result.nil?
      result = Height.where("identity_id = 1").order("measurement_date DESC NULLS LAST").limit(1).first
    end
    result
  end
end
