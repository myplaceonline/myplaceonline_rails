class Group < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :group_name, presence: true
  
  has_many :group_contacts, :dependent => :destroy
  accepts_nested_attributes_for :group_contacts, allow_destroy: true, reject_if: :all_blank

  has_many :group_references, :foreign_key => 'parent_group_id'
  accepts_nested_attributes_for :group_references, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :group_references, [{:name => :group}]

  def display
    group_name
  end
end
