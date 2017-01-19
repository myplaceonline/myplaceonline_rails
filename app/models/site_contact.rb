class SiteContact < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :subject, presence: true
end
