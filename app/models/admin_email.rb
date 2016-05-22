class AdminEmail < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :email
  accepts_nested_attributes_for :email, reject_if: :all_blank
end
