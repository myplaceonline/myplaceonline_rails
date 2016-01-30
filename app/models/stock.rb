class Stock < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  DEFAULT_STOCKS_VEST_THRESHOLD_SECONDS = 30.days

  validates :num_shares, presence: true
  
  def display
    Myp.appendstrwrap(company.display, num_shares.to_s)
  end
  
  belongs_to :company
  accepts_nested_attributes_for :company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :company
  validates :company, presence: true

  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :password
  
  def self.calendar_item_display(calendar_item)
    stock = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.stocks.upcoming",
      name: stock.display,
      delta: Myp.time_difference_in_general_human(TimeDifference.between(User.current_user.time_now, stock.vest_date).in_general)
    )
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if !vest_date.nil?
      ActiveRecord::Base.transaction do
        CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, model_id: id)
        User.current_user.primary_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            User.current_user.primary_identity,
            calendar,
            self.class,
            vest_date,
            (calendar.stocks_vest_threshold_seconds || DEFAULT_STOCKS_VEST_THRESHOLD_SECONDS),
            Calendar::DEFAULT_REMINDER_TYPE,
            model_id: id
          )
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(User.current_user.primary_identity, self.class, self.id)
  end
end
