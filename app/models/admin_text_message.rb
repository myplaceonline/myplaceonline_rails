class AdminTextMessage < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :text_message
  accepts_nested_attributes_for :text_message, reject_if: :all_blank
end
