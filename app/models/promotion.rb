class Promotion < ActiveRecord::Base
  belongs_to :owner, class: Identity
  validates :promotion_name, presence: true
  
  def display
    result = promotion_name
    if !promotion_amount.nil?
      result += " (" + Myp.number_to_currency(promotion_amount) + ")"
    end
    if !expires.nil?
      result += " (" + I18n.t("myplaceonline.promotions.expires") + " " + Myp.display_date_short_year(expires, User.current_user) + ")"
    end
    result
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
