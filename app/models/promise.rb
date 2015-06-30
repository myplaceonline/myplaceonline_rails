class Promise < ActiveRecord::Base
  belongs_to :identity
  validates :name, presence: true
  
  def display
    result = name
    if !due.nil?
      result += " (" + I18n.t("myplaceonline.promises.due") + " " + Myp.display_date_short(due, User.current_user) + ")"
    end
    result
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
