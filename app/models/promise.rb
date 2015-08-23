class Promise < MyplaceonlineIdentityRecord
  validates :name, presence: true
  
  def display
    result = name
    if !due.nil?
      result += " (" + I18n.t("myplaceonline.promises.due") + " " + Myp.display_date_short(due, User.current_user) + ")"
    end
    result
  end
end
