class SiteContact < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true
  validates :subject, presence: true
end
