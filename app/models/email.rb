class Email < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :subject, presence: true
  validates :body, presence: true
  validates :email_category, presence: true

  def display
    subject
  end
end
