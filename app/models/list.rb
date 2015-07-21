class List < ActiveRecord::Base
  belongs_to :owner, class_name: Identity
  validates :name, presence: true

  has_many :list_items, :foreign_key => 'list_id', :dependent => :destroy
  accepts_nested_attributes_for :list_items, allow_destroy: true, reject_if: :all_blank
  
  def display
    name
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
