class PermissionShareChild < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :subject_class, presence: true
  validates :subject_id, presence: true

  belongs_to :share
  belongs_to :permission_share

  def display
    id.to_s
  end
end
