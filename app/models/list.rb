class List < ActiveRecord::Base
  belongs_to :identity
  validates :name, presence: true

  has_many :list_items, :foreign_key => 'list_id', :dependent => :destroy
  accepts_nested_attributes_for :list_items, allow_destroy: true, reject_if: :all_blank
end
